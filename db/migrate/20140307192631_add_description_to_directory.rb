class AddDescriptionToDirectory < ActiveRecord::Migration
  def change
    add_column :directories, :description, :string
  end
end
