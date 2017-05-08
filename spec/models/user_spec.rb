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

  describe '#create_with_steam_id' do
    context 'user has not set up steam account' do
      let!(:user) {User.create_with_steam_id "76561197967876119"}
      subject{ user } 

        
      its(:provider) { should eq "steam" }
      its(:uid) { should eq "76561197967876119" }
      its(:nickname) { should eq "Boofie [NGC|ST]" }
      its(:avatar_url) { should_not be_nil }
      its(:avatar_icon_url) { should_not be_nil }

    end

  end

end
