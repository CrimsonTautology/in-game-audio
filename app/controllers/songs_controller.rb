class SongsController < ApplicationController
  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @song = Song.create( song_params )
  end

  def song_params
    params.require(:song).permit(:sound)
  end
end
