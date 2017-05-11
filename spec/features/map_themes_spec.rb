require 'spec_helper'

describe "map theme song manager" do
  let!(:root) { FactoryGirl.create(:root) }
  subject { page }

  describe "GET /map_themes" do
    
    context "not-logged in as admin" do
      let!(:user) { FactoryGirl.create(:user) }
      before do
        login user
        visit map_themes_path
      end

      its(:status_code) { should eq 403 }
    end

    context "logged in as admin" do
      let!(:user) { FactoryGirl.create(:admin) }
      let(:song) { FactoryGirl.create(:song, name: "allthefoo") }
      let(:another_song) { FactoryGirl.create(:song, name: "allthebaz") }
      let(:map_theme) { FactoryGirl.create(:map_theme, song: song) }
      
      before do
        login user
        visit map_themes_path
      end

      its(:status_code) { should eq 200 }
      it { should have_content(map_theme.map) }
      it { should have_content(song.full_path) }

      it "lets you add new map themes" do
        fill_in "Map", with: "koth_ashville"
        fill_in "Song", with: another_song.full_path
        click_on "Add New Map Theme"
        expect(page).to have_content(another_song.full_path)
        expect(page).to have_content("koth_ashville")
      end

      it "lets you delete map themes" do
        click_on "delete"
        expect(page).to_not have_content(map_theme.map)
      end

    end

  end

end
