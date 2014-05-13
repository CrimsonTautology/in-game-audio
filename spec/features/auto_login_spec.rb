require 'spec_helper'

describe "auto-logging-in via a url token" do

  subject { page }

  describe "GET /*?uid={uid}&login_token={login_token}" do

    context "No token in url" do
      let!(:user) {FactoryGirl.create(:user, uid: "54321", provider: "steam", login_token: nil)}

      before do
        visit "/"
      end

      its(:status_code) { should eq 200}
      specify { expect(current_user).to be_nil }
    end

    context "with valid login token that is not invalidated" do

      let!(:user) {FactoryGirl.create(:user, uid: "54321", provider: "steam", login_token: "123", login_token_invalidated_at: 1.hour.since)}

      before do
        visit "/?login_token=#{user.login_token}"
      end

      its(:status_code) { should eq 200}
      specify { expect(current_user).to eql(user) }
    end

    context "with valid login token that is has been invalidated" do

      let!(:user) {FactoryGirl.create(:user, uid: "54321", provider: "steam", login_token: "123", login_token_invalidated_at: 1.hour.ago)}

      before do
        visit "/?login_token=#{user.login_token}"
      end

      its(:status_code) { should eq 200}
      specify { expect(current_user).to be_nil }
    end

  end
end
