class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :name, null: false
      t.integer :directory_id, null: false
      t.string :title
      t.string :album
      t.string :artist
      t.integer :duration
      t.integer :uploader_id
      t.integer :play_count
      t.string :file_hash
      t.boolean :map_themeable
      t.boolean :user_themeable

      t.timestamps
    end
  end
end
