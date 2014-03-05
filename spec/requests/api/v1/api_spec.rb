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

  describe "/song_query" do
    let!(:root) {FactoryGirl.create(:root)}
    let!(:sub) {FactoryGirl.create(:directory, name: "foo", parent: root)}
    let!(:song) {FactoryGirl.create(:song, name: "jazz", directory: sub)}
    route = "/v1/api/song_query"

    it_should_behave_like "ApiController", route, {
      path: "foo/bar",
    }

    context "with valid access_token" do
      let!(:api_key) {FactoryGirl.create(:api_key)}

      it "returns the song id if it matches correctly" do
        post route,
          access_token: api_key.access_token,
          path: "foo/jazz"
        expect(json['song_id']).to eq song.id
      end
      it "returns a random sub song if it maches a directory" do
        post route,
          access_token: api_key.access_token,
          path: "foo"
        expect(json['song_id']).to eq song.id
      end

      it "returns false if a match was not found" do
        post route,
          access_token: api_key.access_token,
          path: "baz/jazz"
        expect(json['found']).to eq(false)
      end

    end

  end


end

