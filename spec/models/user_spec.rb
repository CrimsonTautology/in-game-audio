require 'spec_helper'

describe User do
  let!(:user) {FactoryGirl.create(:user, uid: "239319123")}
  subject{ user }

  its(:profile_url) { should eq "http://steamcommunity.com/profiles/239319123" }

  it "can be banned" do
    user.banned_at = Time.now
    user.save
    user.reload
    expect(user).to be_banned
  end

end
