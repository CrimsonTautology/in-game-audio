require 'carrierwave/processing/mime_types'
require 'audioinfo'

class SongUploader < CarrierWave::Uploader::Base
  include CarrierWave::MimeTypes
  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  process :extract_sound_details
  process :extract_file_details

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "public/uploads/#{model.directory.full_path}"
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    %w(mp3 mp4 ogg)
  end


  def extract_sound_details
    AudioInfo.open(file.path) do |audio|
      model.title = audio.title
      model.album = audio.album
      model.artist = audio.artist
      model.duration =  audio.length
    end
  end

  def extract_file_details
    model.sound_content_type = file.content_type if file.content_type
    model.sound_file_size = file.size
    model.sound_fingerprint = Digest::MD5.hexdigest(self.file.read)
  end

end
