require 'carrierwave/processing/mime_types'
require 'audioinfo'

class SongUploader < CarrierWave::Uploader::Base
  include CarrierWave::MimeTypes
  # Choose what kind of storage to use for this uploader:
  # storage :file
  # storage :fog

  process :extract_original_file_details
  process :convert_to_ogg
  process :extract_converted_file_details

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "public/uploads/#{model.directory.full_path}"
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    %w(mp3 mp4 ogg)
  end

  def full_filename(for_file)
    model.name + '.ogg'
  end


  def extract_original_file_details
    AudioInfo.open(file.path) do |audio|
      model.title = audio.title
      model.album = audio.album
      model.artist = audio.artist
      model.duration =  audio.length
    end

    model.sound_content_type = file.content_type if file.content_type
    model.sound_fingerprint = Digest::MD5.hexdigest(self.file.read)
  end

  def extract_converted_file_details
    model.sound_file_size = file.size
  end

  def convert_to_ogg
    #ffmpeg -y -i @file -acodec libvorbis -vn -sn -aq 6 -ar 44100 -ac 2 @out.ogg
    cache_stored_file! if !cached?

    directory = File.dirname current_path
    tmp_path  = File.join directory, "tmpfile"
    File.rename current_path,  tmp_path

    file = FFMPEG::Movie.new(tmp_path)
    opts={
      audio_codec: "libvorbis",
      audio_bitrate: 32,
      audio_sample_rate: 22050,
      audio_channels: 1,
      custom: "-vn -sn -f ogg"
    }
    file.transcode(current_path, opts)

    File.delete tmp_path

  end

end
