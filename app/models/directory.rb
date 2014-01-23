class Directory < ActiveRecord::Base
  has_many :songs, dependent: :destroy
  has_many :subdirectories, class_name: "Directory", foreign_key: "parent_id", dependent: :destroy

  belongs_to :parent, class_name: "Directory"

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
