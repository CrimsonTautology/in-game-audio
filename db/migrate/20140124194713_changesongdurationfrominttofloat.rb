class Changesongdurationfrominttofloat < ActiveRecord::Migration
  def change
    change_column :songs, :duration, :float, { default: 0.0 }
  end
end
