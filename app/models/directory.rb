class Directory < ActiveRecord::Base
  has_many :songs, dependent: :destroy
  has_many :subdirectories, class_name: "Directory", foreign_key: "parent_id", dependent: :destroy

  belongs_to :parent, class_name: "Directory"

  validates :name,
    uniqueness: { scope: :parent_id, message: "A directory cannot have two immediate subdirectories of the same name", case_sensitive: false},
    format: { with: /\A[a-zA-Z0-9_]+\z/, unless: :root?, message: "Only numbers, letters or underscores" }

  validates_presence_of :parent_id, unless: :root?
  validates_uniqueness_of :root, if: :root?
  

  def full_path
    if root?
      ""
    else
      "#{parent.full_path}#{name}/"
    end
  end

  def self.root
    where(root: true).first
  end

  def find_or_create_subdirectory name
    sub = Directory.find_by(parent: self, name: name)
    unless sub
      sub = Directory.new
      sub.parent = self
      sub.name = name
      sub.save
    end
    
    sub
  end

end
