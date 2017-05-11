class MapTheme < ActiveRecord::Base
  belongs_to :song

  attr_accessor :full_path
  validates_presence_of :map
  validates_presence_of :song
  validates_uniqueness_of :map

end
