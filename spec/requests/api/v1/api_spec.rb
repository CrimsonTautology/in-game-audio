require "spec_helper"

shared_examples_for "ApiController" do |route,params|
  context "without access_token" do
    before {post route, params}
    its(:code) { should eql("403")}
  end
  context "with invalid access_token" do
    before do
      ApiKey.delete_all
      post route, params.merge({access_token: "badtoken"})
    end
    its(:code) { should eql("403")}
  end

  context "with valid access_token" do
    let!(:api_key) {FactoryGirl.create(:api_key)}
    params.each_key do |key|
      it "should complain about missing #{key}" do
        post route, params.except(key).merge({access_token: api_key.access_token})
        expect(response).to be_bad_request
      end
    end

    it "should pass" do
      post route, params.merge({access_token: api_key.access_token})
      expect(response).to be_success
    end
  end
end

describe "POST /v1/api" do
  subject { response }

  describe "/query_song" do
    let!(:root) {FactoryGirl.create(:root)}
    let!(:sub) {FactoryGirl.create(:directory, name: "foo", parent: root)}
    let!(:song) {FactoryGirl.create(:song, name: "jazz", directory: sub)}
    let!(:user) {FactoryGirl.create(:user, uid: "309134131")}
    route = "/v1/api/query_song"

    it_should_behave_like "ApiController", route, {
      path: "foo/bar",
      uid: "309134131"
    }

    context "with valid access_token" do
      let!(:api_key) {FactoryGirl.create(:api_key)}

      it "returns the song id if it matches correctly" do
        post route,
          access_token: api_key.access_token,
          path: "foo/jazz",
          uid: user.uid
        expect(json['song_id']).to eq song.id.to_s
      end
      it "returns a random sub song if it maches a directory" do
        post route,
          access_token: api_key.access_token,
          path: "foo",
          uid: user.uid
        expect(json['song_id']).to eq song.id.to_s
      end

      it "returns a play_event token if a match is found for a p" do
        post route,
          access_token: api_key.access_token,
          path: "foo/jazz",
          pall: false,
          uid: user.uid
        access_token = json['access_token']
        expect(PlayEvent.find_by(access_token: access_token, type_of: "p", song: song, user: user, api_key: api_key)).to_not be_nil
      end

      it "returns a play_event token if a match is found for a pall" do
        post route,
          access_token: api_key.access_token,
          path: "foo/jazz",
          pall: true,
          uid: user.uid
        access_token = json['access_token']
        expect(PlayEvent.find_by(access_token: access_token, type_of: "pall", song: song, user: user, api_key: api_key)).to_not be_nil
      end

      it "returns false if a match was not found" do
        post route,
          access_token: api_key.access_token,
          path: "baz/jazz",
          uid: user.uid
        expect(json['found']).to eq(false)
      end

      it "passes back if it was a pall or forced" do
        post route,
          access_token: api_key.access_token,
          path: "foo/jazz",
          pall: true,
          force: true,
          uid: user.uid
        expect(json['pall']).to eq(true)
        expect(json['force']).to eq(true)
      end

    end

  end

  describe "/user_theme" do
    let!(:root) {FactoryGirl.create(:root)}
    let!(:sub) {FactoryGirl.create(:directory, name: "foo", parent: root)}
    let!(:song) {FactoryGirl.create(:song, name: "jazz", directory: sub, user_themeable: true)}
    route = "/v1/api/user_theme"

    it_should_behave_like "ApiController", route, {
      uid: "309134131",
    }

    context "with valid access_token" do
      let!(:user) {FactoryGirl.create(:user)}
      let!(:theme) {FactoryGirl.create(:theme, song: song, user: user)}
      let!(:api_key) {FactoryGirl.create(:api_key)}

      it "returns the song id if a theme is found" do
        post route,
          access_token: api_key.access_token,
          uid: theme.user.uid
        expect(json['song_id']).to eq theme.id.to_s
      end

      it "returns false if a theme was not found for user" do
        theme.destroy
        post route,
          access_token: api_key.access_token,
          uid: theme.user.uid
        expect(json['found']).to eq(false)
      end

      it "returns false if user was not found" do
        user.destroy
        post route,
          access_token: api_key.access_token,
          uid: theme.user.uid
        expect(json['found']).to eq(false)
      end

      it "returns a play_event token if a match is found" do
        post route,
          access_token: api_key.access_token,
          uid: theme.user.uid
        access_token = json['access_token']
        expect(PlayEvent.find_by(access_token: access_token, type_of: "user", song: song, api_key: api_key)).to_not be_nil
      end

    end

  end #user_theme

  describe "/map_theme" do
    let!(:root) {FactoryGirl.create(:root)}
    let!(:sub) {FactoryGirl.create(:directory, name: "foo", parent: root)}
    let!(:song) {FactoryGirl.create(:song, name: "jazz", directory: sub, map_themeable: true)}
    route = "/v1/api/map_theme"

    it_should_behave_like "ApiController", route, {
      map: "cp_test",
    }

    context "with valid access_token" do
      let!(:api_key) {FactoryGirl.create(:api_key)}

      it "returns the song id if a map theme is found" do
        post route,
          access_token: api_key.access_token,
          map: "cp_test"
        expect(json['song_id']).to eq song.id.to_s
      end

      it "does not return non map themeable songs" do
        song.map_themeable = false
        song.save
        post route,
          access_token: api_key.access_token,
          map: "cp_test"
        expect(json['found']).to eq(false)
      end

      it "returns a play_event token if a match is found" do
        post route,
          access_token: api_key.access_token,
          map: "cp_test"
        access_token = json['access_token']
        expect(PlayEvent.find_by(access_token: access_token, type_of: "map", song: song, api_key: api_key)).to_not be_nil
      end

    end
  end #map_theme

  describe "/authorize_user" do
    route = "/v1/api/authorize_user"
    let!(:user) {FactoryGirl.create(:user, uid: "12345", provider: "steam")}

    it_should_behave_like "ApiController", route, {
      uid: "12345",
    }

    context "with valid access_token" do
      let!(:api_key) {FactoryGirl.create(:api_key)}

      it "makes the user an uploader" do
        post route,
          access_token: api_key.access_token,
          uid: user.uid
        user.reload
        expect(user).to be_uploader
      end
    end
  end #authorize_user
end

