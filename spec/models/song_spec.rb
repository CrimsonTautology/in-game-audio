require 'spec_helper'
include ActionDispatch::TestProcess

describe Song do
  let!(:root) {FactoryGirl.create(:root)}
  let!(:sub) {FactoryGirl.create(:directory, name: "foo", parent: root)}
  let!(:song) {FactoryGirl.create(:song, name: "jazz", directory: sub)}


  describe "validations" do
    it "prevents multiple sibling songs of the same name" do
      FactoryGirl.create(:song, name: "baz", directory: sub)
      song.name = "bAz"
      expect(song).to_not be_valid
    end

    it "prevents slashes in name" do
      song.name = "crap/crap"
      expect(song).to_not be_valid
    end

    it "allows underscores, letters and numbers" do
      song.name = "crap_CRAP2"
      expect(song).to be_valid
    end

  end
end
