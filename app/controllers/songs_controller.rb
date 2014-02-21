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
    @song = Song.create_from_full_path(params[:song][:full_path])
    @song.sound = params[:song][:sound]
    if @song.save
      flash[:notice] = "Successfully uploaded song."
      redirect_to @song
    else
      render :action => 'new'
    end
  end

end
