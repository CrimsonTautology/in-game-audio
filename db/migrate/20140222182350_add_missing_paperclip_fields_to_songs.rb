class AddMissingPaperclipFieldsToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :sound_file_name, :string
    add_column :songs, :sound_file_size, :string
    add_column :songs, :sound_contnet_type, :string
  end
end
