class Theme < ActiveRecord::Base
  belongs_to :user, dependent: destroy
  belongs_to :song, dependent: destroy

  attr_accessor :full_path
  validates_presence_of :user
  validates_presence_of :song
  validate :song_is_user_themeable

  private
  def song_is_user_themeable
    errors.add(:base, 'Song is not user themable') unless song.user_themeable
  end

end
