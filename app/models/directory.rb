class Directory < ActiveRecord::Base
  has_many :songs, dependent: :destroy
  has_many :subdirectories, class_name: "Directory", foreign_key: "parent_id", dependent: :destroy

  belongs_to :parent, class_name: "Directory"

  validates :name,
    uniqueness: { scope: :parent_id, message: "A directory cannot have two immediate subdirectories of the same name", case_sensitive: false},
    format: { with: /\A[a-z0-9_]+\z/, unless: :root?, message: "Only numbers, letters or underscores" }
  validate :name_does_not_match_song

  validates_presence_of :parent_id, unless: :root?
  validates_uniqueness_of :root, if: :root?
  
  before_save :update_full_path
  after_save  :update_children

  def self.root
    where(root: true).first
  end

  def find_or_create_subdirectory name, description=nil
    sub = Directory.find_by(parent: self, name: name)
    unless sub
      sub = Directory.new
      sub.parent = self
      sub.name = name
      sub.description=nil
      sub.save
    end
    
    sub
  end
  
  def path_name
    name + "/"
  end

  def update_full_path
    if root?
      self.full_path = ""
    else
      self.full_path = "#{parent.full_path}#{path_name}"
    end
  end

  private
  def name_does_not_match_song
    errors.add(:base, 'Song already exists with same name') if Song.exists?(directory_id: parent, name: name)
  end

  def update_children
    subdirectories.each do |s|
      s.update_full_path
      s.save
    end
    songs.each do |s|
      s.update_full_path
      s.save
    end
  end

  

end
