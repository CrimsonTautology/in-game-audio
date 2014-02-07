class AddSearchKeyToDirectories < ActiveRecord::Migration
  def change
    add_column :directories, :full_path, :string

    add_index :directories, :full_path
    add_index :directories, [:parent_id, :name]
    add_index :directories, :root

    remove_column :songs, :file_hash
  end
end
