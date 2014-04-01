class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :songs, :uploader_id
  end
end
