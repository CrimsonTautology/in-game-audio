class AddSoundFingerprintColumnToSong < ActiveRecord::Migration
  def change
    add_column :songs, :sound_fingerprint, :string
  end
end
