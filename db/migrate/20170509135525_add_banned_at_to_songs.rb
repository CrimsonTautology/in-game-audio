class AddBannedAtToSongs < ActiveRecord::Migration
  def change
    add_column :songs, :banned_at, :datetime
    add_index :songs, :banned_at
  end
end
