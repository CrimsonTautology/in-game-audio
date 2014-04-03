class CreatePlayEvents < ActiveRecord::Migration
  def change
    create_table :play_events do |t|
      t.string :access_token, index: true
      t.string :type_of
      t.datetime :invalidated_at
      t.references :song, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
