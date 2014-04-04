class AddApiKeyIdToPlayEvents < ActiveRecord::Migration
  def change
    add_reference :play_events, :api_key, index: true
  end
end
