class PagesController < ApplicationController
  def home
    limit = params["limit"] || 25
    @recently_uploaded = Song.includes(:uploader).order(created_at: :desc).limit(limit)
    @recently_played = PlayEvent.recent_palls.limit(limit)
    @trending = PlayEvent.trending.limit(limit)
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
