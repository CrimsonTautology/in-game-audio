require 'spec_helper'

describe PlayEvent do
  let!(:root) {FactoryGirl.create(:root)}
  let!(:song) {FactoryGirl.create(:song, directory: root)}
  let!(:user) {FactoryGirl.create(:user)}
  let!(:api_key) {FactoryGirl.create(:api_key)}
  let!(:play_event) {PlayEvent.create(song: song, type_of: "pall", user: user, api_key: api_key)}

  subject { play_event }

  it { should respond_to(:access_token)}
  its(:invalidated_at){ should_not be_nil }
  its(:access_token){ should_not be_nil }

  it "will validate fresh events" do
    play_event.invalidated_at = 1.hour.since
    expect(PlayEvent.authenticate(play_event.access_token)).to_not be_nil 
  end

  it "will not validate old events" do
    play_event.invalidated_at = 1.hour.ago
    play_event.save
    expect(PlayEvent.authenticate(play_event.access_token)).to be_nil 
  end
end
