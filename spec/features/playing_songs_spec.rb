require 'spec_helper'
describe "playing a song" do
  subject { page }

  let!(:root) {FactoryGirl.create(:root)}



  describe "GET /songs/play/:id" do
    let!(:sub) {FactoryGirl.create(:directory, name: "foo", parent: root)}
    let!(:api_key) {FactoryGirl.create(:api_key)}
    let!(:song) do
      FactoryGirl.create(:song,
        name: "fatbeats",
        directory: sub,
        title: "Some Fat Beatz",
        album: "Fat Album",
        artist: "Beatmaster",
        duration: 1234.5,
        play_count: 7
      )
    end

    shared_examples_for "valid access rights" do
      its(:status_code) { should eq 200}
      it { should have_selector "audio#audio_player" }
    end

    context "not logged in" do
      before do
        visit play_song_path song
      end

      its(:status_code) { should eq 403}
    end

    context "logged in as uploader" do
      before do
        login FactoryGirl.create(:uploader)
        visit play_song_path song
      end
      its(:status_code) { should eq 403}
    end


    context "logged in as admin" do
      before do
        login FactoryGirl.create(:admin)
        visit play_song_path song
      end

      it_behaves_like "valid access rights"
    end

    context "with api key" do
      before do
        visit "#{play_song_path(song)}?access_token=#{api_key.access_token}&volume=0.66"
      end

      it_behaves_like "valid access rights"
    end
  end
end
