class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider
      t.string :uid
      t.string :nickname
      t.string :avatar_url
      t.string :avatar_icon_url
      t.boolean :uploader, default: false
      t.boolean :admin, default: false
      t.datetime :banned_at

      t.timestamps
    end
  end
end
