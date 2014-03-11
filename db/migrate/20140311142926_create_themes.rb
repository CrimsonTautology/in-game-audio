class CreateThemes < ActiveRecord::Migration
  def change
    create_table :themes do |t|
      t.references :user, index: true
      t.references :song, index: true

      t.timestamps
    end
  end
end
