require 'spec_helper'

describe "user theme song manager" do
  let!(:root) {FactoryGirl.create(:root)}
  let!(:user) {FactoryGirl.create(:user, uid: "54321", provider: "steam")}

  subject { page }

  shared_examples_for "a user page" do
    its(:status_code) { should eq 200}
    it {should have_content user.nickname }
    it {should have_link("", href: user_songs_path(user)) }
  end

  describe "GET /users/" do
    let!(:user2) {FactoryGirl.create(:user, nickname: 'another guy')}
    before do
      visit "/users/"
    end

    its(:status_code) { should eq 200}

    it {should have_content user.nickname }
    it {should have_link(user.nickname, href: user_path(user)) }

    it {should have_content user2.nickname }
    it {should have_link(user2.nickname, href: user_path(user2)) }
  end

  describe "GET /users/:id" do
    context "not logged in" do
      before do
        visit "/users/#{user.uid}"
      end

      it_behaves_like "a user page"
      it {should_not have_link("", href: user_themes_path(user)) }
      it {should_not have_link("", href: ban_user_path(user)) }
      it {should_not have_link("", href: authorize_user_path(user)) }
    end

    context "logged in as same user" do
      before do
        login user
        visit "/users/#{user.uid}"
      end

      it_behaves_like "a user page"
      it {should have_link( "", href: user_themes_path(user)) }
      it {should_not have_link( "", href: ban_user_path(user)) }
      it {should_not have_link( "", href: authorize_user_path(user)) }
    end

    context "logged in as admin" do
      before do
        login FactoryGirl.create(:admin)
        visit "/users/#{user.uid}"
      end

      it_behaves_like "a user page"
      it {should have_link( "", href: user_themes_path(user)) }
      it {should have_link( "", href: ban_user_path(user)) }
      it {should have_link( "", href: unauthorize_user_path(user)) }

      it "let's you ban and unban users" do
        click_on "Ban"
        expect(user.reload).to be_banned
        click_on "Unban"
        expect(user.reload).to_not be_banned
      end

      it "let's you authorize and unauthorize users" do
        click_on "Unauthorize"
        expect(user.reload).to_not be_uploader
        click_on "Authorize"
        expect(user.reload).to be_uploader
      end
    end
  end
end
