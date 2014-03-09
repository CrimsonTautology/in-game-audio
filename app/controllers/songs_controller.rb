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

    #FIXME Move this to a model
    Directory.transaction do
      raise ActiveRecord::Rollback if params[:song][:directory].blank?
      parent = Directory.find(params[:song][:directory])

      path = params[:song][:full_path]
      directories = path.gsub(/\A\s*\//, "").gsub(/\/\s*\z/, "").split("/")
      name = directories.pop

      directories.each do |dir|
        parent = parent.find_or_create_subdirectory dir
      end

      @song.name = name
      @song.directory = parent
      @song.uploader_id = current_user.id

      raise ActiveRecord::Rollback if @song.invalid?
    end


    if @song.save
      flash[:notice] = "Successfully uploaded #{@song.full_path}."
      redirect_to @song
    else
      flash[:error] = @song.errors.full_messages.to_sentence
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
