class AddSoundToSong < ActiveRecord::Migration
  def change
    add_column :songs, :sound, :string
  end
end
