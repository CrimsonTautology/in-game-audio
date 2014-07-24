require 'spec_helper'

describe Theme do
  let!(:user) { FactoryGirl.create(:user)}
  let!(:root) { FactoryGirl.create(:root)}
  let!(:invalid_song) { FactoryGirl.create(:song, name: "invalid", directory: root, user_themeable: false)}
  let!(:valid_song) { FactoryGirl.create(:song, name: "valid", directory: root, user_themeable: true)}

  specify { expect(Theme.new(user: user, song: invalid_song)).to_not be_valid }
  specify { expect(Theme.new(user: user, song: valid_song)).to be_valid }

  it "auto deletes if the song is deleted" do
    new_song = FactoryGirl.create(:song, directory: root, user_themeable: true)
    theme = Theme.create(user: user, song: new_song)
    expect{ new_song.destroy }.to change(Theme, :count).by(-1)
  end
end
