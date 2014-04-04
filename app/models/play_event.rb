#this model serves two purposes:  to provide an authentication session to
#play a song through the site and to keep a history of played songs
class PlayEvent < ActiveRecord::Base
  validates :type_of, inclusion: { in: %w(p pall map user)}, presence: true
  validates :song, presence: true
  validates :api_key, presence: true

  belongs_to :song
  belongs_to :user
  belongs_to :api_key

  before_create :generate_access_token
  before_create :invalidate_in_an_hour

  def self.authenticate access_token
    PlayEvent.where(access_token: access_token).where("invalidated_at > ?", Time.now).limit(1).first
  end

  def self.recent_palls
    includes(:song, :user, :api_key).where(type_of: "pall").order(created_at: :desc)
  end

  def self.trending
    select("song_id, count(id) as play_count").includes(:song).where(type_of: %W{p pall}).where('created_at >= ?', 2.weeks.ago).group(:song_id).order("play_count desc")
  end

  private

  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end while PlayEvent.exists?(access_token: access_token)
  end

  def invalidate_in_an_hour
    self.invalidated_at = 1.hour.since
  end
end
