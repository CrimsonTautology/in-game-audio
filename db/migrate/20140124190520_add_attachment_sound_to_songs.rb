class AddAttachmentSoundToSongs < ActiveRecord::Migration
  def self.up
    change_table :songs do |t|
      t.attachment :sound
    end
  end

  def self.down
    drop_attached_file :songs, :sound
  end
end
