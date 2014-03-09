module V1
  class ApiController < ApplicationController
    skip_before_filter :verify_authenticity_token
    authorize_resource class: false
    before_filter :check_api_key
    before_filter :check_path, only: [:query_song]
    respond_to :json

    def query_song
      song = Song.path_search @path
      pall = params["pall"] == 'true' || params["pall"] == "1"
      force = params["force"] == 'true' || params["force"] == "1"
      if song.nil?
        out = {
          found: false,
          command: "query_song"
        }
      else
        out = {
          found: true,
          command: "query_song",
          pall: pall,
          force: force,
          song_id: song.id.to_s,
          full_path: song.full_path,
          title: song.title,
          album: song.album,
          artist: song.artist,
          description: song.to_s,
          duration: song.duration.to_i,
          duration_formated: song.duration_formated
        }
      end
      render json: out
    end


    private
    def check_api_key
      api_key = ApiKey.authenticate(params[:access_token])
      head :unauthorized unless api_key
    end

    def check_path
      @path = params["path"]
      head :bad_request unless @path
    end

  end
end

