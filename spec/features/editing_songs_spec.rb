require 'spec_helper'
describe "editing songs" do
  subject { page }

  let!(:root) {FactoryGirl.create(:root)}
  let!(:sub1) {FactoryGirl.create(:directory, name: "n", description: "test description", parent: root)}
  let!(:sub2) {FactoryGirl.create(:directory, name: "pop", parent: sub1)}
  let!(:song) {FactoryGirl.create(:song, name: "yay", directory: sub2)}

  describe "GET /songs/edit" do

    shared_examples_for "valid access rights" do

      context "auto fill" do
        before do
          visit edit_song_path song
        end

        it { should have_content "yay" }
        it { should have_content sub1.to_label }
        it { should_not have_content "pop/yay" }
      end

      context "changing category" do
        before do
          visit edit_song_path song
          fill_in "Name", with: "pop/yay"
          select "n/", from: "Category"
          click_button "Edit Song"
        end

        #it_behaves_like "a successful upload", "n/pop/yay"

      end

    end

    shared_examples_for "a successful upload" do |full_path|
      specify { expect(Song.find_by_full_path full_path).to_not be_nil }
      specify { expect(Directory.find_by_full_path full_path.gsub(%r{/[^/]*$}, '/')).to_not be_nil }
      specify { expect(current_path).to eq song_path(Song.find_by_full_path full_path) }
    end
    shared_examples_for "a failed upload" do
      specify { expect( Song.count ).to eq 0 }
      specify { expect( Directory.count ).to eq 2}
      specify { expect(current_path).to eq new_song_path }
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
        login FactoryGirl.create(:uploader, id: song.uploader_id + 1)
        visit edit_song_path song
      end

      its(:status_code) { should eq 403}
    end

    context "logged in as song's uploader" do
      before do
        user = FactoryGirl.create(:uploader)
        song.uploader_id = user.id
        login user
        visit edit_song_path song
      end

      it_behaves_like "valid access rights"
    end

    context "logged in as admin" do
      before do
        login FactoryGirl.create(:admin)
        visit edit_song_path song
      end

      it_behaves_like "valid access rights"
    end


  end
end
