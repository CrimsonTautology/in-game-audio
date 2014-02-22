require 'spec_helper'
describe "Song Pages" do
  subject { page }

  describe "GET /songs/:id" do
    let!(:root) {FactoryGirl.create(:root)}
    let!(:sub) {FactoryGirl.create(:directory, name: "foo", parent: root)}
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

    before do
      visit song_path song
    end

    its(:status_code) { should eq 200}
    it { should have_content(song.full_path) }
    it { should have_content(song.title) }
    it { should have_content(song.album) }
    it { should have_content(song.artist) }
    it { should have_content(song.duration_formated) }
    it { should have_content("Song has been played #{song.play_count} times") }
    pending "As admin" do
      before do
        visit current_path
      end

      it { should have_link("Edit this song", edit_song_path(song)) }
    end
  end

  describe "GET /songs/new" do

  end
end
