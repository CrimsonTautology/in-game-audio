class SongsController < ApplicationController
  load_and_authorize_resource

  before_filter :find_song, only: [:show, :play, :edit, :update, :destroy]

  def index
    @songs = Song.includes(:uploader).filter(params).paginate(page: params[:page], per_page: 32)
  end

  def show
  end

  def play
    @volume = params[:volume] || "1.0"
    @volume = @volume.to_f * 100
    @seek = params[:seek] || 0
  end

  def new
    @song = Song.new
    @categories = Directory.where(parent: Directory.root).order(full_path: :asc)
  end

  def edit
    @directories = Directory.where(root: false).order(full_path: :asc)
  end

  def create
    path = params[:song][:full_path]
    category = params[:song][:directory]
    @song = Song.new(create_params)
    @song.uploader_id = current_user.id
    @song.set_with_path_and_category path, category


    if @song.save
      flash[:notice] = "Successfully uploaded #{@song.full_path}."
      redirect_to @song
    else
      flash[:error] = @song.errors.full_messages.to_sentence
      redirect_to new_song_path
    end
  end

  def update
    if @song.update_attributes(update_params)
      @song.reload
      flash[:notice] = "Successfully updated #{@song.full_path}."
      redirect_to @song
    else
      flash[:error] = @song.errors.full_messages.to_sentence
      redirect_to edit_song_path @song
    end

  end

  def destroy
    @song.destroy
    redirect_to directory_path(@song.directory), notice: "Deleted #{@song.full_path}"
  end

  private
  def create_params
    params.require(:song).permit(:full_path, :sound)
  end

  def update_params
    authorize! :map_themeable, @song unless params[:song][:map_themeable].nil?
    authorize! :user_themeable, @song unless params[:song][:user_themeable].nil?
    params.require(:song).permit(:name, :directory_id, :title, :artist, :album, :map_themeable, :user_themeable)
  end

  def find_song
    @song = Song.find(params[:id])
  end

end
