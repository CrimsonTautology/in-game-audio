class CreateDirectories < ActiveRecord::Migration
  def change
    create_table :directories do |t|
      t.boolean :root, default: false
      t.string :name, null: false
      t.integer :parent_id

      t.timestamps
    end
  end
end
