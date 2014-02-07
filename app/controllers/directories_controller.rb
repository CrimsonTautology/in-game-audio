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
    if params[:id].nil?
      @directory = Directory.includes(:subdirectories, :songs).root
    else
      @directory = Directory.includes(:subdirectories, :songs).find(params[:id])
    end
    @subdirectories = @directory.subdirectories
    @songs = @directory.songs
  end
end
