class Directory < ActiveRecord::Base
  has_many :songs, dependent: :destroy
  has_many :subdirectories, class_name: "Directory", foreign_key: "parent_id", dependent: :destroy

  belongs_to :parent, class_name: "Directory"
end
