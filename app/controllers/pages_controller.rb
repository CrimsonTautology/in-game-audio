class PagesController < ApplicationController
  def home
  end

  def help
    @rock = Directory.find_by(name: "r", parent: Directory.root)
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
