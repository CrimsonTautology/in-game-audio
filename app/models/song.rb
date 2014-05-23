class Song < ActiveRecord::Base
  belongs_to :directory
  belongs_to :uploader, class_name: "User"

  attr_accessor :add_as_theme
  attr_accessor :path
  attr_accessor :category

  mount_uploader :sound, SongUploader
  #process_in_background :sound

  has_many :themes
  has_many :play_events

  validates :name,
    uniqueness: { scope: :directory_id, message: "A directory cannot have two songs of the same name", case_sensitive: false},
    format: { with: /\A[a-z0-9_]+\z/, message: "can only be numbers, letters or underscores" }
  validates :directory_id,
    presence: true
  validate  :name_does_not_match_directory
  validates :uploader_id,
    presence: true
  validates :sound_fingerprint,
    uniqueness: { allow_blank: true, message: "matches a song that has already been uploaded"}
  validates :sound_content_type,
    presence: true,
    inclusion: {in: %w(audio/mp3 audio/mp4 audio/mpeg audio/ogg audio/flac audio/vnd.wave) , message: "is invalid (%{value})" }
  validates :sound_file_size,
    presence: true,
    numericality: { less_than_or_equal_to: (10.megabytes), message: "is too large; must be less than 10 megabytes" }



  before_save :update_full_path
  before_save :check_if_user_themable


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
        "#{name} - #{artist}"
      elsif album.present?
        "#{name} - #{album}"
      else
        name
      end
    end
  end

  def to_json_api
    {
      song_id: id.to_s,
      full_path: full_path,
      title: title,
      album: album,
      artist: artist,
      description: to_s,
      duration: duration.to_i,
      duration_formated: duration_formated
    }
  end

  def to_p_command
    "!p #{full_path}"
  end

  def to_pall_command
    "!pall #{full_path}"
  end

  def self.filter attributes
    attributes.inject(self) do |scope, (key, value)|
      return scope if value.blank?
      case key.to_sym
      when :search
        scope.search(value)
      when :name
        scope.search(value, :name)
      when :title
        scope.search(value, :title)
      when :artist
        scope.search(value, :artist)
      when :album
        scope.search(value, :album)
      when :user_themeable
        scope.where(user_themeable: true)
      when :map_themeable
        scope.where(map_themeable: true)
      when :user_id
        scope.joins(:uploader).where(users: {uid: value})
      when :directory_id
        scope.where(directory_id: value)
      when :sort
        case value.to_sym
        when :file_size
          scope.order(sound_file_size: :desc)
        when :duration
          scope.order(duration: :desc)
        when :updated
          scope.order(updated_at: :desc)
        when :created
          scope.order(created_at: :desc)
        when :play_count
          scope.order(play_count: :desc)
        when :uploader
          scope.order(uploader_id: :desc)
        when :name
          scope.order(name: :asc)
        when :full_path
          scope.order(full_path: :asc)
        when :title
          scope.order(title: :asc)
        when :artist
          scope.order(artist: :asc)
        when :album
          scope.order(album: :asc)
        end
      else
        scope
      end
    end
  end

  def self.random
    offset(rand count).first
  end

  #Return a song by it's path or a random sub song if path matches a directory
  def self.path_search path
    key = path.strip.gsub %r{^/|/$}, ""

    if key == ""
      return Song.random
    end

    song = Song.find_by_full_path key
    if song
      return song
    elsif Directory.exists?(full_path: key + "/")
      return Song.where("full_path like :q", q: "#{key}/%").random
    else 
      return nil
    end
  end

  def self.search(query, type=nil)
    #Use postgre text search
    if query.present?
      if Rails.configuration.database_configuration[Rails.env]["adapter"].eql? "postgresql"
        case type
        when :name
          where("name ilike :q", q: "%#{query}%")
        when :title
          where("title ilike :q", q: "%#{query}%")
        when :album
          where("album ilike :q", q: "%#{query}%")
        when :artist
          where("artist ilike :q", q: "%#{query}%")
        else
          where("name ilike :q OR title ilike :q OR album ilike :q OR artist ilike :q", q: "%#{query}%")
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
      scope
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
    errors.add(:base, 'Directory already exists with same name') if directory.nil? || Directory.exists?(parent: directory, name: name)
  end

  def check_if_user_themable
    unless user_themeable
      self.user_themeable = duration <= 10.0
    end
    true
  end

end
