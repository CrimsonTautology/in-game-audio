class SongsController < ApplicationController
  def index
  end

  def show
    @song = Song.find(params[:id])
  end

  def new
    @song = Song.new
  end

  def edit
  end

  def create
    path = params[:song][:full_path]
    directories = path.gsub(/\A\s*\//, "").gsub(/\/\s*\z/, "").split("/")
    name = directories.pop
    @song = Song.new(song_params)
    @song.name = name
    @song.directory = Directory.root

    if @song.save
      flash[:notice] = "Successfully uploaded #{@song.full_path}."
      redirect_to @song
    else
      redirect_to new_song_path
    end
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
