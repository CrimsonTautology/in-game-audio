# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

unless Directory.exists?(root: true)
  root = Directory.new
  root.root = true
  root.name = ""
  root.description = "Root Directory"
  root.save!

end

root = Directory.root

root.find_or_create_subdirectory "a", "Anime"
root.find_or_create_subdirectory "b", "Blues"
root.find_or_create_subdirectory "c", "Classical"
root.find_or_create_subdirectory "ch", "Chorus"
root.find_or_create_subdirectory "com", "Comedy"
root.find_or_create_subdirectory "ct", "Country"
root.find_or_create_subdirectory "d", "Disco/Funk"
root.find_or_create_subdirectory "e", "Electronic"
root.find_or_create_subdirectory "f", "Folk"
root.find_or_create_subdirectory "g", "Gimmick"
root.find_or_create_subdirectory "h", "House/Dance/Rave"
root.find_or_create_subdirectory "hh", "Hip Hop"
root.find_or_create_subdirectory "in", "Instrumental"
root.find_or_create_subdirectory "j", "Jazz/Big Band"
root.find_or_create_subdirectory "l", "Latin/Salsa"
root.find_or_create_subdirectory "m", "Metal"
root.find_or_create_subdirectory "mu", "Musical"
root.find_or_create_subdirectory "mv", "Movie Soundtracks"
root.find_or_create_subdirectory "n", "Noise"
root.find_or_create_subdirectory "old", "Oldies"
root.find_or_create_subdirectory "pop", "Pop"
root.find_or_create_subdirectory "prog", "Progressive Rock"
root.find_or_create_subdirectory "pu", "Punk"
root.find_or_create_subdirectory "r", "Rock"
root.find_or_create_subdirectory "rap", "Rap"
root.find_or_create_subdirectory "reg", "Reggae"
root.find_or_create_subdirectory "rmx", "Remix"
root.find_or_create_subdirectory "sfx", "Sound Effects"
root.find_or_create_subdirectory "ska", "Ska"
root.find_or_create_subdirectory "sw", "Spoken Word"
root.find_or_create_subdirectory "sym", "Symphonic / New-Age"
root.find_or_create_subdirectory "tf2", "TF2 Related"
root.find_or_create_subdirectory "tv", "Television Soundtracks"
root.find_or_create_subdirectory "v", "Video Game Soundtracks"
root.find_or_create_subdirectory "w", "Asian"
