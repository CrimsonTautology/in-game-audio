class DirectoriesController < ApplicationController
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

  private
  def find_directory
    if params[:id].blank?
      @directory = Directory.includes(:subdirectories, :songs).root
    else
      full_path = params[:id].chomp("/") + "/"
      @directory = Directory.includes(:subdirectories, :songs).find_by(full_path: full_path)
    end
    @subdirectories = @directory.subdirectories
    @songs = @directory.songs
  end
end
