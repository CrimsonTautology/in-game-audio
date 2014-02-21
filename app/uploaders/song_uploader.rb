# encoding: utf-8

class SongUploader < CarrierWave::Uploader::Base
  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  process :extract_sound_details

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "public/uploads/#{model.directory.full_path}"
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    %w(mp3)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    "#{model.name}.mp3" if original_filename
  end

  def extract_sound_details
    opts = { encoding: 'utf-8' }
    Mp3Info.open(file.path, opts) do |mp3|
      model.title = mp3.tag.title
      model.album = mp3.tag.album
      model.artist = mp3.tag.artist
      model.duration =  mp3.length
    end
  end

end
