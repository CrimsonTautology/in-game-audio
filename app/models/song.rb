class Song < ActiveRecord::Base
  belongs_to :directory

  validates :name, uniqueness: { scope: :directory_id, message: "A directory cannot have two songs of the same name", case_sensitive: false}
end
