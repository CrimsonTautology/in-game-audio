class AddHollidayThemesToSong < ActiveRecord::Migration
  def change
    add_column :songs, :halloween_themeable, :boolean, default: false
    add_column :songs, :christmas_themeable, :boolean, default: false

    add_index :songs, :halloween_themeable
    add_index :songs, :christmas_themeable
  end
end
