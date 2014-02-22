class AddMissingPaperclipFieldsToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :sound_file_name, :string
    add_column :songs, :sound_file_size, :integer
    add_column :songs, :sound_content_type, :string
  end
end
