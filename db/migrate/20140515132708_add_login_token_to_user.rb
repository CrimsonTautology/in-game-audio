class AddLoginTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :login_token, :string
    add_index  :users, :login_token
    add_column :users, :login_token_invalidated_at, :datetime
  end
end
