require 'spec_helper'
describe "searching for songs" do
  subject { page }

  let!(:root) {FactoryGirl.create(:root)}

  describe "GET /songs/:id" do
    let!(:sub) {FactoryGirl.create(:directory, name: "foo", parent: root)}
    let!(:song1) {FactoryGirl.create(:song, name: "fatbeats", directory: sub, title: "Some Fat Beatz", album: "Fat Album", artist: "Beatmaster")}
    let!(:song2) {FactoryGirl.create(:song, name: "namestuff", directory: sub, title: "Some Stuff", album: "", artist: "Beatmaster")}
    let!(:song3) {FactoryGirl.create(:song, name: "foo", directory: sub, title: "Foo Master", album: "stuffington", artist: "Bob")}
    let!(:song4) {FactoryGirl.create(:song, name: "bar", directory: root, title: "Bar Master", album: "steave", artist: "Mr. Stuff")}

    before do
      visit directories_path
      fill_in "search", with: "stuff"
      click_on "Search"
    end

    specify{ expect(current_path).to eq songs_path }
    it { should_not have_link "", href: song_path(song1)}
    it { should_not have_content song1.to_s }

    it { should have_link song2.full_path, href: song_path(song2) }
    it { should have_content song2.to_s }

    it { should have_link song3.full_path, href: song_path(song3) }
    it { should have_content song3.to_s }

    pending { should have_link song4.full_path, href: song_path(song2) }
    it { should have_content song4.to_s }

  end
end
