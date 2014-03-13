class ThemesController < ApplicationController
  load_and_authorize_resource :user
  load_and_authorize_resource :theme, through: :user

  def index
    @themes = User.find(params[:user_id]).themes.includes(:song)
  end

  def create
    theme = Theme.new
    theme.song = Song.where(create_params).first
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

  private
  def create_params
    params.require(:theme).permit(:full_path)
  end
end
