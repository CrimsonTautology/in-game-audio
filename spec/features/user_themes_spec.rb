require 'spec_helper'

describe "user theme song manager" do
  let!(:root) {FactoryGirl.create(:root)}
  let!(:user) {FactoryGirl.create(:user)}

  subject { page }

  describe "GET /users/:id/themes" do
    before do
      login user
    end

    context "as different user" do
      before do
        visit user_themes_path(FactoryGirl.create(:user))
      end

      its(:status_code) { should eq 403}

    end

    context "with no themes" do
      before do
        visit user_themes_path(user)
      end

      its(:status_code) { should eq 200}
    end

    context "with theme" do
      let!(:song) {FactoryGirl.create(:song, directory: root, user_themeable: true)}
      let!(:theme) { FactoryGirl.create(:theme, song: song, user: user) }
      before do
        visit user_themes_path(user)
      end

      its(:status_code) { should eq 200}
      it { should have_content song.full_path }
      it { should have_content song.to_s }
      it { should have_button "delete" }

      it "deletes the theme when you click delete" do
        click_on "delete"
        expect(Theme.count).to eq 0
      end
    end

    describe "adding a theme" do

      context "with valid song" do
        let!(:sub) {FactoryGirl.create(:directory, name: "bop", parent: root)}
        let!(:song) {FactoryGirl.create(:song, name: "beep", directory: sub, user_themeable: true)}
        before do
          visit user_themes_path(user)
          fill_in "Full path", with: song.full_path
          click_on "Add New Theme"
        end

        specify { expect(Theme.count).to eq 1 }
        it { should have_content song.full_path }

      end

      context "with invalid song" do
        let!(:sub) {FactoryGirl.create(:directory, name: "bop", parent: root)}
        let!(:song) {FactoryGirl.create(:song, name: "beep", directory: sub, user_themeable: false)}
        before do
          visit user_themes_path(user)
          fill_in "Full path", with: song.full_path
          click_on "Add New Theme"
        end

        specify { expect(Theme.count).to eq 0 }
        it { should_not have_content song.full_path }

      end
    end
  end

end
