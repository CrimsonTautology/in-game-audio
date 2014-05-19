require 'spec_helper'

describe "auto-logging-in via a url token" do

  subject { page }

  let!(:root) {FactoryGirl.create(:root)}

  context "with no token in url" do
    let!(:user) {FactoryGirl.create(:user, uid: "54321", nickname: "Test User 1234", provider: "steam", login_token: nil)}

    before do
      visit "/"
    end

    its(:status_code) { should eq 200}
    it { should have_link("", "/auth/steam") }
  end

  context "with valid login token that is not invalidated" do

    let!(:user) {FactoryGirl.create(:user, uid: "54321", provider: "steam", login_token: "123", login_token_invalidated_at: 1.hour.since)}

    before do
      visit "/?login_token=#{user.login_token}"
    end

    its(:status_code) { should eq 200}
    it { should have_link("Log Out", logout_path) }

    it "keeps you logged in" do
      click_on "Add Song"
      expect(page.status_code).to eq 200
    end

  end

  context "with valid login token that has been invalidated" do

    let!(:user) {FactoryGirl.create(:user, uid: "54321", provider: "steam", login_token: "123", login_token_invalidated_at: 1.hour.ago)}

    before do
      visit "/?login_token=#{user.login_token}"
    end

    its(:status_code) { should eq 200}
    it { should have_link("", "/auth/steam") }
  end

  context "with bogus login token" do

    let!(:user) {FactoryGirl.create(:user, uid: "54321", provider: "steam", login_token: "123", login_token_invalidated_at: 1.hour.since)}

    before do
      visit "/?login_token=crap1234"
    end

    its(:status_code) { should eq 200}
    it { should have_link("", "/auth/steam") }
  end

end
