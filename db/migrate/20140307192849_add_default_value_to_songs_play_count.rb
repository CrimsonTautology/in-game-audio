class AddDefaultValueToSongsPlayCount < ActiveRecord::Migration
  def change
    change_column :songs, :play_count, :integer, default: 0
    change_column :songs, :map_themeable, :boolean, default: false
    change_column :songs, :user_themeable, :boolean, default: false
  end
end
