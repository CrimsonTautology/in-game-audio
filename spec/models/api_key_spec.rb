require 'spec_helper'

describe ApiKey do
  let!(:api_key) {ApiKey.create(name: "test")}
  it { should respond_to(:access_token)}
  it "generates an access token on save" do
    expect(api_key.access_token).to_not be_nil
  end

  specify { expect(ApiKey.authenticate(api_key.access_token)).to_not be_nil }
end
