require 'spec_helper'
describe "Song Pages" do
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
    before do
      SongUploader.enable_processing = true
    end

    after do
      SongUploader.enable_processing = false
    end

    context "not submiting a song file" do
      before do
        visit new_song_path
        fill_in "Full path", with: "n/pop/yay"
        click_button "Create Song"
      end

      specify { expect(Song.find_by_full_path "n/pop/yay").to be_nil }
      specify { expect(Directory.find_by_full_path "n/pop/").to be_nil }
      specify { expect(current_path).to eq new_song_path }
    end

    context "submiting a valid song file" do
      before do
        visit new_song_path
        fill_in "Full path", with: "n/pop/yay"
        attach_file "Sound", Rails.root.join('spec', 'fixtures', 'files', 'test.mp3')
        click_button "Create Song"
      end

      specify { expect(Song.find_by_full_path "n/pop/yay").to exist }
      specify { expect(Directory.find_by_full_path "n/pop/").to exist }
      specify { expect(current_path).to eq song_path(Song.find_by_full_path "n/pop/yay") }
    end

  end
end
