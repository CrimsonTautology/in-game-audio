module V1
  class ApiController < ApplicationController
    authorize_resource class: false
    before_filter :check_api_key
    before_filter :check_path, only: [:song_query]
    respond_to :json

    def song_query
      song = Song.path_search @path
      if song.nil?
        out = {
          found: false,
          command: "song_query"
        }
      else
        out = {
          found: true,
          command: "song_query",
          song_id: song.id,
          full_path: song.full_path,
          title: song.title,
          album: song.album,
          artist: song.artist,
          duration: song.duration,
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

