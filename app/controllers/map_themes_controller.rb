class MapThemesController < ApplicationController
  authorize_resource

  def index
    @map_themes = MapTheme.all
  end

  def create
    @map_theme = MapTheme.create(map_theme_params)
    if @map_theme.valid?
      flash[:notice] = "New Map Theme Added"
    else
      flash[:error] = @map_theme.errors.full_messages.to_sentence
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
      params.require(:map_theme).permit(:map, :song_id)
    end
end
