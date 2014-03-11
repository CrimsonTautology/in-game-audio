class Song < ActiveRecord::Base
  belongs_to :directory
  belongs_to :uploader, class_name: "User"
  mount_uploader :sound, SongUploader

  has_many :themes

  validates :name,
    uniqueness: { scope: :directory_id, message: "A directory cannot have two songs of the same name", case_sensitive: false},
    format: { with: /\A[a-z0-9_]+\z/, message: "can only be numbers, letters or underscores" }
  validate  :name_does_not_match_directory
  validates :directory_id,
    presence: true
  validates :uploader_id,
    presence: true
  validates :sound_fingerprint,
    uniqueness: { allow_blank: true, message: "matches a song that has already been uploaded"}
  validates :sound_content_type,
    presence: true,
    inclusion: {in: %w(audio/mp3 audio/mp4 audio/mpeg audio/ogg) , message: "is invalid (%{value})" }
  validates :sound_file_size,
    presence: true,
    numericality: { less_than_or_equal_to: (10.megabytes), message: "is too large; must be less than 10 megabytes" }



  before_save :update_full_path
  #before_save :check_user_themable


  def update_full_path
    self.full_path = "#{directory.full_path}#{name}"
  end

  def duration_formated
    Time.at(duration).gmtime.strftime("%R:%S")
  end

  def to_s
    if title.present?
      if artist.present?
        "#{title} - #{artist}"
      elsif album.present?
        "#{title} - #{album}"
      else
        title
      end
    else
      if artist.present?
        "#{full_path} - #{artist}"
      elsif album.present?
        "#{full_path} - #{album}"
      else
        full_path
      end
    end
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

  def set_with_path_and_category path, category
    Directory.transaction do
      raise ActiveRecord::Rollback if category.blank?
      parent = Directory.find(category)

      directories = path.gsub(/\A\s*\//, "").gsub(/\/\s*\z/, "").split("/")
      name = directories.pop

      directories.each do |dir|
        parent = parent.find_or_create_subdirectory dir
      end

      self.name = name
      self.directory = parent

      raise ActiveRecord::Rollback if invalid?
    end
  end
  

  private

  def name_does_not_match_directory
    errors.add(:base, 'Directory already exists with same name') if Directory.exists?(parent: directory, name: name)
  end

  def check_user_themable
    user_themeable = (duration <= 10.seconds) if user_themeable.nil?
  end

end
