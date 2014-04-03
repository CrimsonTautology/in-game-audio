require 'spec_helper'

describe "Song Directories" do
  subject { page }

  let!(:root) {FactoryGirl.create(:root)}

  describe "GET /" do
    before do
      visit root_path
    end

    its(:status_code) { should eq 200}
  end

  describe "GET /help" do
    before do
      visit help_path
    end

    its(:status_code) { should eq 200}
  end

  describe "GET /contact" do
    before do
      visit contact_path
    end

    its(:status_code) { should eq 200}
  end

  describe "GET /stop" do
    before do
      visit stop_path
    end

    its(:status_code) { should eq 200}
  end

  describe "GET /admin" do
    before do
      visit admin_path
    end

    its(:status_code) { should eq 403}

    context "as admin" do
      before do
        login FactoryGirl.create(:admin)
        visit admin_path
      end

      its(:status_code) { should eq 200}
    end
  end
end
