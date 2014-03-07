class DirectoriesController < ApplicationController
  authorize_resource
  before_filter :find_directory

  def index
    render "show"
  end
  def show
  end

  def edit
  end

  def update
  end

  def destroy
    unless @directory.root?
      @directory.destroy
      flash[:notice] = "Delted #{@directory.full_path}"
      redirec_to directory_path(@directory.parent)
    else
      flash[:error] = "Cannot delete root directory"
      redirec_to directories_path
    end
  end

  private
  def find_directory
    if params[:id].nil?
      @directory = Directory.includes(:subdirectories, :songs).root
    else
      @directory = Directory.includes(:subdirectories, :songs).find(params[:id])
    end
    @subdirectories = @directory.subdirectories
    @songs = @directory.songs
  end
end
