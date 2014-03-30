class AddRememberMeTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :remember_me_token, :string
    add_index :users, :remember_me_token
  end
end
