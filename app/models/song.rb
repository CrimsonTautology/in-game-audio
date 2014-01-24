class Song < ActiveRecord::Base
  belongs_to :directory

  validates :name, uniqueness: { scope: :directory_id, message: "A directory cannot have two songs of the same name", case_sensitive: false}

  has_attached_file :sound, styles: { format: :mp3, convert_options: { ar: '44100', ac: '2', ab: '192000' }, processors: [:mp3] }

  def full_path
    "#{directory.full_path}#{name}"
  end

  def self.create_from_full_path full_path
    directories = full_path.gsub(/\A\s*\//, "").gsub(/\/\s*\z/, "").split("/")
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
end
