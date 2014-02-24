class SongsController < ApplicationController
  def index
  end

  def show
    @song = Song.find(params[:id])
  end

  def new
  end

  def edit
  end

  def create
    Directory.transaction do
      @song = Song.create_from_full_path(params[:song][:full_path])
      @song.sound = params[:song][:sound]
      raise ActiveRecord::Rollback if @song.invalid?
    end

    if @song.save
      flash[:notice] = "Successfully uploaded song."
      redirect_to @song
    else
      redirect_to new_song_path
    end
  end

end
