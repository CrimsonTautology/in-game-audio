require 'spec_helper'
describe "editing songs" do
  subject { page }

  let!(:root) {FactoryGirl.create(:root)}
  let!(:sub1) {FactoryGirl.create(:directory, name: "n", description: "test description", parent: root)}
  let!(:sub2) {FactoryGirl.create(:directory, name: "pop", parent: sub1)}
  let!(:song) {FactoryGirl.create(:song, name: "yay", directory: sub2, title: "old title", artist: "old title", album: "old album")}

  describe "GET /songs/edit" do
    before do
      User.destroy_all
    end

    shared_examples_for "valid access rights" do

      describe "changing song info" do
        before do
          visit edit_song_path song
          fill_in "Title", with: "new title"
          fill_in "Artist", with: "new artist"
          fill_in "Album", with: "new album"
          click_button "Update Song"
          song.reload
        end

        specify { expect(song.title).to eq "new title" }
        specify { expect(song.artist).to eq "new artist" }
        specify { expect(song.album).to eq "new album" }

      end

      describe "changing category" do
        before do
          visit edit_song_path song
          fill_in "Name", with: "new"
          select "n/pop/", from: "Directory"
          click_button "Update Song"
        end

        specify { expect(Song.find_by_full_path "n/pop/new").to_not be_nil }
        specify { expect(Song.find_by_full_path "n/pop/yay").to be_nil }
        specify { expect(Song.find_by_full_path "n/pop/new").to eq song }

      end

      context "song already existing" do
        let!(:uploader) {FactoryGirl.create(:uploader, id: 666)} #FIXME Why isn't factory girl getting a unique id?
        let!(:existing_song) {FactoryGirl.create(:song, name: "new", directory: sub2, uploader: uploader)}
        before do
          visit edit_song_path song
          fill_in "Name", with: "new"
          select "n/pop/", from: "Directory"
          click_button "Update Song"
        end

        specify { expect(Song.find_by_full_path "n/pop/new").to_not be_nil }
        specify { expect(Song.find_by_full_path "n/pop/yay").to_not be_nil }
        specify { expect(Song.find_by_full_path "n/pop/new").to_not eq song }
        specify { expect(Song.find_by_full_path "n/pop/new").to eq existing_song }

      end

    end

    context "not logged in" do
      before do
        visit edit_song_path song
      end

      its(:status_code) { should eq 403}
    end

    context "logged in" do
      before do
        login FactoryGirl.create(:user)
        visit edit_song_path song
      end
      its(:status_code) { should eq 403}
    end


    context "logged in as different uploader" do
      before do
        login FactoryGirl.create(:uploader, id: (song.uploader_id + 1))
        visit edit_song_path song
      end

      its(:status_code) { should eq 403}
    end

    context "logged in as song's uploader" do
      before do
        login FactoryGirl.create(:uploader, id: song.uploader_id)
        visit edit_song_path song
      end

      it_behaves_like "valid access rights"
      it { should_not have_content "Map themeable" }
      it { should_not have_content "User themeable" }
    end

    context "logged in as admin" do
      before do
        FactoryGirl.create(:user, id: song.uploader_id )
        login FactoryGirl.create(:admin, id: song.uploader_id + 1)
        visit edit_song_path song
      end

      it_behaves_like "valid access rights"
      it { should have_content "Map themeable" }
      it { should have_content "User themeable" }

      describe "setting themeables" do
        before do
          check "Map themeable"
          check "User themeable"
          click_button "Update Song"
          song.reload
        end

        specify { expect(song).to be_map_themeable }
        specify { expect(song).to be_user_themeable }
      end


    end
  end
end
