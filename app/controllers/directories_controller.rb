class DirectoriesController < ApplicationController
  authorize_resource
  before_filter :find_directory, only: [:index, :show, :edit, :create, :update, :destroy]

  def index
    render "show"
  end
  def show
  end

  def new
    @directory = Directory.new
    @directories = Directory.order(full_path: :asc).all
  end

  def edit
  end

  def create
    @directory = Directory.new(create_params)
    if @directory.save
      @directory.reload
      flash[:notice] = "Successfully created #{@directory.full_path}."
      redirect_to @directory
    else
      flash[:error] = @directory.errors.full_messages.to_sentence
      redirect_to new_directory_path
    end

  end

  def update
    if @directory.update_attributes(update_params)
      @directory.reload
      flash[:notice] = "Successfully updated #{@directory.full_path}."
      redirect_to @directory
    else
      flash[:error] = @directory.errors.full_messages.to_sentence
      redirect_to edit_directory_path @directory
    end
  end

  def destroy
    if @directory.root?
      flash[:error] = "Cannot delete root directory"
      redirect_to directories_path
    elsif @directory.songs.count > 0 || @directory.subdirectories.count > 0
      flash[:error] = "Cannot delete non-empty directory"
      redirect_to @directory
    else
      @directory.destroy
      flash[:notice] = "Deleted #{@directory.full_path}"
      redirect_to directory_path(@directory.parent)
    end
  end

  private
  def find_directory
    if params[:id].nil?
      @directory = Directory.includes(:subdirectories, :songs).root
    else
      @directory = Directory.includes(:subdirectories, :songs).find(params[:id])
    end
    @subdirectories = @directory.subdirectories.order(name: :asc)
    @songs = @directory.songs.includes(:uploader).order(name: :asc)
  end

  def create_params
    params.require(:directory).permit(:name, :parent_id, :description)
  end
  def update_params
    params.require(:directory).permit(:name, :description)
  end
end
