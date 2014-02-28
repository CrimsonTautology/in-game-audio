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
    before :all do
      SongUploader.enable_processing = true
    end

    after :all do
      SongUploader.enable_processing = false
      CarrierWave.clean_cached_files!
    end

    shared_examples_for "a successful upload" do |full_path|
      specify { expect(Song.find_by_full_path full_path).to_not be_nil }
      specify { expect(Directory.find_by_full_path full_path.gsub(%r{/[^/]*$}, '/')).to_not be_nil }
      specify { expect(current_path).to eq song_path(Song.find_by_full_path full_path) }
    end
    shared_examples_for "a failed upload" do
      specify { expect( Song.count ).to eq 0 }
      specify { expect( Directory.count ).to eq 1}
      specify { expect(current_path).to eq new_song_path }
    end

    context "not submiting a song file" do
      before do
        visit new_song_path
        fill_in "Full path", with: "n/pop/yay"
        click_button "Create Song"
      end

      it_behaves_like "a failed upload"
      it { should have_content "Sound content type is invalid" }

    end

    context "submitting an invalid file type" do
      before do
        visit new_song_path
        fill_in "Full path", with: "n/pop/yay"
        attach_file "Sound", Rails.root.join('spec', 'fixtures', 'files', 'dangerous_file.exe')
        click_button "Create Song"
      end

      it_behaves_like "a failed upload"
      it { should have_content "Sound content type is invalid" }

    end

    context "submitting the same file again" do
      before do
        same = FactoryGirl.create(:song, directory: root, sound_fingerprint: "fingerprint")
        Digest::MD5.stub(:hexdigest) { "fingerprint" }
        visit new_song_path
        fill_in "Full path", with: "n/pop/yay"
        attach_file "Sound", Rails.root.join('spec', 'fixtures', 'files', 'test.mp3')
        click_button "Create Song"
        same.destroy
      end

      it_behaves_like "a failed upload"
      it { should have_content "has already been uploaded" }

    end

    context "submiting a valid song file" do
      before do
        visit new_song_path
        fill_in "Full path", with: "n/pop/yay"
        attach_file "Sound", Rails.root.join('spec', 'fixtures', 'files', 'test.mp3')
        click_button "Create Song"
      end

      it_behaves_like "a successful upload", "n/pop/yay"

    end

  end
end
