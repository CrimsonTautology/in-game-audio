class ThemesController < ApplicationController
  before_filter :find_user
  before_filter :authorization

  def index
    @themes = @user.themes.includes(:song)
  end

  def create
    theme = Theme.new
    theme.song = Song.where(create_params).first
    theme.user = @user
    if theme.save
      flash[:notice] = "New Theme Added"
    else
      flash[:error] = "Can not use that song as theme"
    end
    redirect_to user_themes_path(@user)
  end

  def destroy
    Theme.find(params[:id]).destroy
    flash[:notice] = "Theme removed"
    redirect_to user_themes_path(@user)
  end

  private
  def create_params
    params.require(:theme).permit(:full_path)
  end

  def find_user
    @user = User.find_by(provider: "steam", uid: params[:user_id])
  end

  def authorization
    #FIXME I can not get cancan to work niceley with this
    head :forbidden unless current_user && (@user.id == current_user.id || current_user.admin?)
  end
end
