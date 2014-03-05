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
    inclusion: {in: %w(audio/mp3 audio/mp4 audio/mpeg audio/ogg) , message: "is invalid (%{value})" }
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

  #Return a song by it's path or a random sub song if path matches a directory
  def self.path_search path
    key = path.strip.gsub %r{^/|/$}, ""
    song = Song.find_by_full_path key
    if song
      return song
    elsif key == ""
      songs = Song.all
      return songs[rand songs.length]
    elsif Directory.exists?(full_path: key + "/")
      songs = Song.where("full_path like :q", q: "#{key}%")
      return songs[rand songs.length]
    else 
      return nil
    end
  end

  def self.search(query, type=nil)
    #Use postgre text search
    if query.present?
      if Rails.configuration.database_configuration[Rails.env]["database"].eql? "postgresql"
        case type
        when :name
          where("name @@ :q", q: query)
        when :title
          where("title @@ :q", q: query)
        when :album
          where("album @@ :q", q: query)
        when :artist
          where("artist @@ :q", q: query)
        else
          where("name @@ :q OR title @@ :q OR album @@ :q OR artist @@ :q", q: query)
        end
      else
        case type
        when :name
          where("name like :q", q: "%#{query}%")
        when :title
          where("title like :q", q: "%#{query}%")
        when :album
          where("album like :q", q: "%#{query}%")
        when :artist
          where("artist like :q", q: "%#{query}%")
        else
          where("name like :q OR title like :q OR album like :q OR artist like :q", q: "%#{query}%")
        end
      end
    else
      scoped
    end
  end
  

  private

  def name_does_not_match_directory
    errors.add(:base, 'Directory already exists with same name') if Directory.exists?(parent: directory, name: name)
  end

end
