json.array!(@map_themes) do |map_theme|
  json.extract! map_theme, :id, :map, :song_id
  json.url map_theme_url(map_theme, format: :json)
end
