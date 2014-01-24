require "mp3info"

class Song < ActiveRecord::Base
  belongs_to :directory

  validates :name, uniqueness: { scope: :directory_id, message: "A directory cannot have two songs of the same name", case_sensitive: false}

  has_attached_file :sound,
    styles: { 
      format: :mp3,
      convert_options: { 
        ar: '44100',
        ac: '2',
        ab: '192000'
      },
      processors: [:mp3]
    },
    url:  "public/attachments/:name/",
    path: "public/attachments/:name/"

  validates :sound,
    attachment_presence: true,
    size: { in: 0..6.megabytes }

  before_save :extract_sound_details

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

  private
  def extract_sound_details
    path = sound.queued_for_write[:original].path
    opts = { encoding: 'utf-8' }
    Mp3Info.open(path, opts) do |mp3|
      self.title = mp3.tag.title
      self.album = mp3.tag.album
      self.artist = mp3.tag.artist
      self.duration =  mp3.length
    end
  end
end
