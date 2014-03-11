class ThemesController < ApplicationController
  authorize_resource

  def index
    @themes = User.find_by_uid(params[:user_id]).themes.includes(:song)
  end

  def create
    theme = Theme.new
    theme.song = Song.find_by_full_path(params[:theme][:full_path])
    theme.user = current_user
    if theme.save
      flash[:notice] = "New Theme Added"
    else
      flash[:error] = "Can not use that song as theme"
    end
    redirect_to user_themes_path(current_user)
  end

  def destroy
    Theme.find(params[:id]).destroy
    flash[:notice] = "Theme removed"
    redirect_to user_themes_path(current_user)
  end
end
