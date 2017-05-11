require 'spec_helper'

describe MapTheme do
  let!(:root) { FactoryGirl.create(:root)}
  let!(:song) { FactoryGirl.create(:song, name: "valid", directory: root)}
  let!(:existing_map_theme) { FactoryGirl.create(:map_theme, map: "koth_existing") }

  specify { expect(MapTheme.new(map: "pl_badwater", song: song)).to be_valid }

  it "won't let you create two themes with the same map name" do
    expect(MapTheme.new(map: existing_map_theme.map)).to_not be_valid
  end

  it "auto deletes if the song is deleted" do
    new_song = FactoryGirl.create(:song, directory: root)
    map_theme = MapTheme.create(song: new_song)
    expect{ new_song.destroy }.to change(MapTheme, :count).by(-1)
  end
end
