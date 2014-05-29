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
    @seek = params[:seek] || 0

    #Convert to logrithmic scale
    @volume = (@volume.to_f ** 4.0).round(5).to_s
  end

  def new
    @song = Song.new
    @categories = Directory.where(parent: Directory.root).order(full_path: :asc)
  end

  def edit
    @directories = Directory.where(root: false).order(full_path: :asc)
  end

  def create
    path = params[:song][:path]
    category = params[:song][:category]
    @song = Song.new(create_params)
    @song.uploader = current_user
    @song.set_with_path_and_category path, category


    if @song.save

      #Check if we should add this song as a theme
      @song.reload
      if params[:song][:add_as_theme] == "1"
        Theme.create(user: current_user, song: @song)
      end

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
    params.require(:song).permit(:sound)
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
