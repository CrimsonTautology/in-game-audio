require 'spec_helper'

describe "admin control panel" do

  subject { page }

  describe "GET /admin/" do

    context "not logged in at all" do
      before do
        visit admin_path
      end

      its(:status_code) { should eq 403}
    end

    context "not logged in as admin" do
      before do
        login FactoryGirl.create(:user)
        visit admin_path
      end

      its(:status_code) { should eq 403}
    end

    context "logged in as admin" do
      before do
        login FactoryGirl.create(:admin)
        visit admin_path
      end

      its(:status_code) { should eq 200}

      context "click on Uploaders" do
        let!(:uploader) {FactoryGirl.create(:user, nickname: "Is Uploader", uploader: true)}
        let!(:not_uploader) {FactoryGirl.create(:user, nickname: "Not an Uploader", uploader: false)}
        before do
          not_uploader.uploader=false
          not_uploader.save
          click_on "Uploaders"
        end

        its(:status_code) { should eq 200}
        it {should have_content uploader.nickname}
        it {should_not have_content not_uploader.nickname}
      end

      context "click on Admins" do
        let!(:admin) {FactoryGirl.create(:admin, nickname: "Is an admin")}
        let!(:not_admin) {FactoryGirl.create(:user, nickname: "Not an Admin", admin: false)}
        before do
          click_on "Admins"
        end

        its(:status_code) { should eq 200}
        it {should have_content admin.nickname}
        it {should_not have_content not_admin.nickname}
      end

      context "click on Banned" do
        let!(:banned) {FactoryGirl.create(:banned, nickname: "Is a banned user 123")}
        let!(:not_banned) {FactoryGirl.create(:user, nickname: "Not banned", banned_at: nil)}
        before do
          click_on "Banned Users"
        end

        its(:status_code) { should eq 200}
        it {should have_content banned.nickname}
        it {should_not have_content not_banned.nickname}
      end

    end

  end

end
