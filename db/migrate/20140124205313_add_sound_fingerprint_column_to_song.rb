class AddSoundFingerprintColumnToSong < ActiveRecord::Migration
  def change
    remove_column :songs, column: :file_hash
    add_column :songs, :sound_fingerprint, :string
  end
end
