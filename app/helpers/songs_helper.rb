module SongsHelper

  def bootstrap_class_for_song song
    if song.banned? && is_admin?
      "bg-danger text-white"
    else
      ""
    end
  end

end
