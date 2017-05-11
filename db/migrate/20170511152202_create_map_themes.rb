class CreateMapThemes < ActiveRecord::Migration
  def change
    create_table :map_themes do |t|
      t.string :map
      t.references :song, index: true

      t.timestamps
    end
    add_index :map_themes, :map, unique: true
  end
end
