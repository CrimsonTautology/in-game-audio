class AddSearchKeyToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :full_path, :string

    add_index :songs, :full_path
    add_index :songs, [:title, :album, :artist]
    add_index :songs, [:directory_id, :name]
  end
end
