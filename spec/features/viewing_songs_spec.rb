require 'spec_helper'
describe "viewing song information" do
  subject { page }

  let!(:root) {FactoryGirl.create(:root)}

  describe "GET /songs/:id" do
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

    shared_examples_for "valid access rights" do
      its(:status_code) { should eq 200}
      it { should have_content(song.full_path) }
      it { should have_content(song.title) }
      it { should have_content(song.album) }
      it { should have_content(song.artist) }
      it { should have_content(song.duration_formated) }
      it { should have_content("Song has been played #{song.play_count} times") }
    end

    context "not logged in" do
      before do
        visit song_path song
      end

      it_behaves_like "valid access rights"
    end

    context "logged in" do
      before do
        login FactoryGirl.create(:user)
        visit song_path song
      end
      it_behaves_like "valid access rights"
    end


    context "logged in as admin" do
      before do
        login FactoryGirl.create(:admin)
        visit song_path song
      end

      it_behaves_like "valid access rights"
      it { should have_link("Edit this song", edit_song_path(song)) }
      it { should have_link("Listen to this song", play_song_path(song)) }
    end
  end
end
