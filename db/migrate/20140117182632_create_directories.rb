class CreateDirectories < ActiveRecord::Migration
  def change
    create_table :directories do |t|
      t.bool :root
      t.string :name
      t.directory :parent

      t.timestamps
    end
  end
end
