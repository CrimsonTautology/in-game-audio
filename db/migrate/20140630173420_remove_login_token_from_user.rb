class RemoveLoginTokenFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :login_token
    remove_column :users, :login_token_invalidated_at
  end
end
