class Song < ActiveRecord::Base
  belongs_to :directory
  mount_uploader :sound, SongUploader

  validates :name,
    uniqueness: { scope: :directory_id, message: "A directory cannot have two songs of the same name", case_sensitive: false},
    format: { with: /\A[a-z0-9_]+\z/, message: "Only numbers, letters or underscores" }
  validate  :name_does_not_match_directory
  validates :sound_fingerprint, uniqueness: {allow_blank: true, message: "File has already been uploaded"}
  validates :sound_content_type, inclusion: {in: %w(audio/mp3) }
  validates :sound_file_size, inclusion: { in: 0..10.megabytes }


  before_save :update_full_path


  def self.create_from_full_path path
    directories = path.gsub(/\A\s*\//, "").gsub(/\/\s*\z/, "").split("/")
    name = directories.pop

    parent = Directory.root
    directories.each do |dir|
      parent = parent.find_or_create_subdirectory dir
    end

    Song.create do |s|
      s.name = name
      s.directory = parent
    end.save
  end

  def update_full_path
    self.full_path = "#{directory.full_path}#{name}"
  end

  private

  def name_does_not_match_directory
    errors.add(:base, 'Directory already exists with same name') if Directory.exists?(parent: directory, name: name)
  end

end
