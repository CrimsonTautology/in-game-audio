require 'audioinfo'

class SongUploader < CarrierWave::Uploader::Base

  process :extract_original_file_details

  version :ogg do
    process :convert_to_ogg

    def full_filename(for_file)
      model.sound_file_name + '.ogg'
    end
  end

  process :convert_to_mp3
  process :extract_converted_file_details

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "public/uploads/#{model.sound_fingerprint[0, 2]}/#{model.sound_fingerprint}"
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_whitelist
    %w(mp3 mp4 ogg wav m4a)
  end


  def extract_original_file_details
    AudioInfo.open(file.path) do |audio|
      model.title = audio.title
      model.album = audio.album
      model.artist = audio.artist
      model.duration =  audio.length
    end

    model.sound_fingerprint = Digest::MD5.hexdigest(self.file.read)
    model.sound_file_name = File.basename(file.path, ".*").parameterize
  end

  def extract_converted_file_details
    model.sound_content_type = file.content_type if file.content_type
    model.sound_file_size = file.size
  end

  def full_filename(for_file)
    model.sound_file_name + '.mp3'
  end

  def convert_to_mp3
    #ffmpeg -y -i @file -vn -sn -aq 6 -ar 44100 -ac 2 @out.mp3
    cache_stored_file! if !cached?

    directory = File.dirname current_path
    tmp_path  = File.join directory, "tmpfile"
    File.rename current_path,  tmp_path

    file = FFMPEG::Movie.new(tmp_path)
    opts={
      audio_codec: "libmp3lame",
      audio_bitrate: 32,
      audio_sample_rate: 22050,
      audio_channels: 1,
      custom: "-vn -aq 4 -sn -f mp3"
    }
    file.transcode(current_path, opts)

    File.delete tmp_path
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
