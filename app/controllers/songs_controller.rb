class SongsController < ApplicationController
  authorize_resource

  def index
    @songs = Song.search(params[:search])
  end

  def show
    @song = Song.find(params[:id])
  end

  def play
    @volume = params[:volume] || 1.0
    @song = Song.find(params[:id])
  end

  def new
    @song = Song.new
    @categories = Directory.root.subdirectories
  end

  def edit
  end

  def create
    @song = Song.new(song_params)
    @song.uploader_id = current_user.id
    @song.set_with_path_and_category params[:song][:full_path], params[:song][:directory]


    if @song.save
      flash[:notice] = "Successfully uploaded #{@song.full_path}."
      redirect_to @song
    else
      flash[:error] = @song.errors.full_messages.to_sentence
      redirect_to new_song_path
    end
  end

  def update

  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    redirect_to songs_path, notice: "Deleted #{@song.full_path}"
  end

  private
  def song_params
    params.require(:song).permit(:full_path, :sound)
  end

end
