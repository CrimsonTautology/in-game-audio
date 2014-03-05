module V1
  class ApiController < ApplicationController
    #authorize_resource class: false
    before_filter :check_path, only: [:song_query]
    respond_to :json

    def song_query
      out = {
        found: false,
        command: "song_query"
      }
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

