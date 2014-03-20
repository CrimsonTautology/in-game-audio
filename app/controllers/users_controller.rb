class UsersController < ApplicationController
  before_filter :find_user, only: [:show, :edit, :update, :ban, :unban, :authorize, :unauthorize]
  load_and_authorize_resource

  def index
    @users = User.filter( params ).load
  end

  def show
    authorize! :read, @user

  end

  def edit
  end
  def update
    @user.admin = params[:user][:admin]
    @user.uploader = params[:user][:uploader]
    if @user.save
      redirect_to(@user)
    else
      flash[:alert] = "Could not update user"
      render action: 'edit'
    end

  end
  def ban
    if !@user.banned?
      @user.banned_at = Time.now
      @user.save!
      flash[:notice] = "Banned User"
    else
      flash[:alert] = "User already banned"

    end
    redirect_to(@user)
  end
  def unban
    @user.banned_at = nil
    @user.save!
    flash[:notice] = "Unbanned User"
    redirect_to(@user)
  end

  def authorize
    if !@user.uploader?
      @user.uploader = true
      @user.save!
      flash[:notice] = "Authorized User"
    else
      flash[:alert] = "User already authorized"

    end
    redirect_to(@user)
  end
  def unauthorize
    @user.uploader = false
    @user.save!
    flash[:notice] = "Unauthorized User"
    redirect_to(@user)
  end

  private
  def find_user
    @user = User.find_by(provider: "steam", uid: params[:id])
  end
end

