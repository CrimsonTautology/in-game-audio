class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    session[:user_id] = user.id

    #Add cookie logic
    user.generate_remember_me_token
    user.save
    cookies.permanent.signed[:remember_me_token] = user.remember_me_token

    redirect_to root_url, notice: "Signed in!"
  end

  def destroy
    session[:user_id] = nil
    cookies.signed[:remember_me_token] = nil
    redirect_to root_url, notice: "Signed out!"
  end
end
