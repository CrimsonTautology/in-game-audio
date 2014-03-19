class PagesController < ApplicationController
  def home
  end

  def help
  end

  def contact
  end

  def stop
    render :layout => false
  end

  def admin
    authorize! :admin, :page
  end
end
