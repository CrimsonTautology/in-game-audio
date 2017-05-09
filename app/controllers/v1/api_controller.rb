module V1
  class ApiController < ApplicationController
    skip_before_filter :verify_authenticity_token
    authorize_resource class: false
    before_filter :check_api_key
    before_filter :check_path_or_song_id,   only: [:query_song]
    before_filter :check_search, only: [:search_song]
    before_filter :check_uid,    only: [:query_song, :user_theme, :authorize_user]
    before_filter :check_user,   only: [:query_song, :authorize_user]
    before_filter :check_map,    only: [:map_theme]

    before_filter :get_pall
    before_filter :get_force

    respond_to :json

    def query_song

      #Song_id takes priority over a path search
      if @song_id
        song = Song.unhidden.find_by_id @song_id.to_i
      else
        song = Song.unhidden.path_search @path
      end

      if song.nil?
        #A direct result was not found via path; try finding songs that have path in their name or title
        songs = []
        songs = Song.unhidden.search(@path, :name_and_title).limit(128) if @path

        unless songs.empty?
          #return list back for user to choose which one
          out = {
            found: false,
            multiple: true,
            command: "query_song",
            pall: @pall,
            force: @force,
            songs: songs.map{ |s| {
              description: s.to_s,
              full_path: s.full_path,
              song_id: s.id
            }},
            command: "search_song"
          }

        else
          #Still nothing matches
          out = {
            found: false,
            multiple: false,
            command: "query_song"
          }
        end

      else
        #Create a play event for this song
        play_event = PlayEvent.create(song: song, type_of: (@pall ? "pall" : "p"), user: @user, api_key: @api_key )
        play_event.save

        out = {
          found: true,
          multiple: false,
          command: "query_song",
          pall: @pall,
          force: @force,
          access_token: play_event.access_token
        }.merge song.to_json_api
      end
      render json: out
    end

    def user_theme
      user = User.find_by_uid(@uid)

      if user.nil?
        out = {
          found: false,
          command: "user_theme"
        }
      else
        song = user.theme_songs.random
        if song.nil?
          out = {
            found: false,
            command: "user_theme"
          }
        else
          #Create a play event for this song
          play_event = PlayEvent.create(song: song, type_of: "user", api_key: @api_key )
          play_event.save

          out = {
            found: true,
            command: "user_theme",
            pall: true,
            force: @force,
            access_token: play_event.access_token
          }.merge song.to_json_api
        end
      end
      render json: out
    end

    def map_theme
      halloween = Date.new(Time.now.year, 10, 31)
      christmas = Date.new(Time.now.year, 12, 25)
      if (halloween-2.weeks..halloween+1.week).cover?(Time.now)
        #It's Halloween season
        song = Song.unhidden.where(halloween_themeable: true).random
      elsif (christmas-2.weeks..christmas+1.week).cover?(Time.now)
        #It's Christmas time
        song = Song.unhidden.where(christmas_themeable: true).random
      else
        song = Song.unhidden.where(map_themeable: true).random
      end

      if song.nil?
        out = {
          found: false,
          command: "map_theme"
        }
      else
        play_event = PlayEvent.create(song: song, type_of: "map", api_key: @api_key )
        play_event.save

        out = {
          found: true,
          command: "map_theme",
          pall: true,
          force: @force,
          access_token: play_event.access_token
        }.merge song.to_json_api
      end
      render json: out
    end

    def authorize_user
      @user.uploader = true
      @user.save
      out = {
        uid: @uid,
        command: "authorize_user"
      }

      render json: out
    end

    def search_song
      songs = Song.unhidden.search(@search)

      if songs.empty?
        out = {
          found: false,
          command: "search_song"
        }
      else
        out = {
          found: true,
          songs: songs.map{ |s| {
          description: s.to_s,
          full_path: s.full_path,
          song_id: s.id
        }},
          command: "search_song"
        }
      end

      render json: out
    end

    private
    def check_api_key
      @api_key = ApiKey.authenticate(params[:access_token])
      head :unauthorized unless @api_key
    end

    def check_path_or_song_id
      @path = params["path"]
      @song_id = params["song_id"]
      head :bad_request unless @path || @song_id
    end

    def check_search
      @search = params["search"]
      head :bad_request unless @search
    end

    def check_uid
      @uid = params["uid"]
      head :bad_request unless @uid
    end

    def check_user
      @user = User.find_by(provider: "steam", uid: @uid) || User.create_with_steam_id(@uid)
      head :bad_request unless @user
    end

    def check_map
      @map = params["map"]
      head :bad_request unless @map
    end

    def get_pall
      @pall = params["pall"] == 'true' || params["pall"] == "1"
    end

    def get_force
      @force = params["force"] == 'true' || params["force"] == "1"
    end

  end
end

