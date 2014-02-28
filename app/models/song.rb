class Song < ActiveRecord::Base
  belongs_to :directory
  mount_uploader :sound, SongUploader

  validates :name,
    uniqueness: { scope: :directory_id, message: "A directory cannot have two songs of the same name", case_sensitive: false},
    format: { with: /\A[a-z0-9_]+\z/, message: "can only be numbers, letters or underscores" }
  validate  :name_does_not_match_directory
  validates :sound_fingerprint,
    uniqueness: { allow_blank: true, message: "matches a song that has already been uploaded"}
  validates :sound_content_type,
    presence: true,
    inclusion: {in: %w(audio/mp3 audio/mp4 audio/mpeg) , message: "is invalid (%{value})" }
  validates :sound_file_size,
    presence: true,
    numericality: { less_than_or_equal_to: (10.megabytes), message: "is too large; must be less than 10 megabytes" }



  before_save :update_full_path


  def update_full_path
    self.full_path = "#{directory.full_path}#{name}"
  end

  def duration_formated
    Time.at(duration).gmtime.strftime("%R:%S")
  end

  private

  def name_does_not_match_directory
    errors.add(:base, 'Directory already exists with same name') if Directory.exists?(parent: directory, name: name)
  end

end
