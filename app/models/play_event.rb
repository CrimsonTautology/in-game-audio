class PlayEvent < ActiveRecord::Base
  validates :type_of, inclusion: { in: %w(p pall map user)}, presence: true
  validates :song, presence: true

  belongs_to :song
  belongs_to :user

  before_create :generate_access_token
  before_create :invalidate_in_an_hour

  def self.authenticate access_token
    PlayEvent.where(access_token: access_token).where("invalidated_at > ?", Time.now).limit(1).first
  end

  private

  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end while PlayEvent.exists?(access_token: access_token)
  end

  def invalidate_in_an_hour
    self.invalidated_at = Time.now + 1.hour
  end
end
