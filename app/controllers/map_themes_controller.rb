class MapThemesController < ApplicationController
  authorize_resource

  def index
    @map_themes = MapTheme.order(map: :asc)
  end

  def create
    map_theme = MapTheme.new
    map_theme.song = Song.where(full_path: map_theme_params[:full_path]).first
    map_theme.map = map_theme_params[:map]
    if map_theme.save
      flash[:notice] = "New Map Theme Added"
    else
      flash[:error] = map_theme.errors.full_messages.to_sentence
    end
    redirect_to map_themes_path
  end

  def destroy
    MapTheme.find(params[:id]).destroy
    flash[:notice] = "Map Theme Deleted!"
    redirect_to map_themes_path
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def map_theme_params
      params.require(:map_theme).permit(:map, :full_path)
    end
end
