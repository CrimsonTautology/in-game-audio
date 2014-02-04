require 'spec_helper'

describe Directory do
  let!(:root) {FactoryGirl.create(:root)}
  let!(:sub) {FactoryGirl.create(:directory, name: "foo", parent: root)}

  describe "#full_path" do
    let!(:sub2) {FactoryGirl.create(:directory, name: "bar", parent: sub)}
    specify { expect(root.full_path).to be_empty}
    specify { expect(sub.full_path).to eql "foo/"}
    specify { expect(sub2.full_path).to eql "foo/bar/"}
  end

  describe ".root" do
    subject {Directory.root}
    its(:id) {should eq root.id}
  end

  describe "#find_or_create_subdirectory" do

    it "creates a subdirectory if it doesn't exist" do
      Directory.delete_all(parent: sub, name: "baz")
      expect{ sub.find_or_create_subdirectory("baz") }.to change(Directory, :count).by(1)
    end

    it "returns the subdirectory if it exists" do
      sub2 = FactoryGirl.create(:directory, parent: sub, name: "baz")
      expect(sub.find_or_create_subdirectory("baz").id ).to eq(sub2.id)
    end

    it "does not return other directories of the same name" do
      sub2 = FactoryGirl.create(:directory, parent: root, name: "baz")
      expect(sub.find_or_create_subdirectory("baz").id ).to_not eq(sub2.id)
    end

  end
end
