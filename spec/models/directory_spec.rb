require 'spec_helper'

describe Directory do
  let!(:root) {FactoryGirl.create(:root)}
  let!(:sub) {FactoryGirl.create(:directory, name: "foo", parent: root)}

  describe "validations" do
    it "prevents multiple sibling directories of the same name" do
      FactoryGirl.create(:directory, name: "baz", parent: sub.parent)
      sub.name = "baz"
      expect(sub).to_not be_valid
    end

    it "prevents slashes in name" do
      sub.name = "crap/crap"
      expect(sub).to_not be_valid
    end

    it "allows underscores, letters and numbers" do
      sub.name = "crap_crap2"
      expect(sub).to be_valid
    end

    it "only let's one directory be root" do
      sub.root = true
      expect(sub).to_not be_valid
    end

    it "won't let not root directories be parentless" do
      sub.parent = nil
      expect(sub).to_not be_valid
    end
  end

  describe "full_path" do
    let!(:sub2) {FactoryGirl.create(:directory, name: "baz", parent: sub)}
    specify { expect(root.full_path).to be_empty}
    specify { expect(sub.full_path).to eql "foo/"}
    specify { expect(sub2.full_path).to eql "foo/baz/"}

    it "changes full_path if directory name chagnes" do
      sub.name = "bar"
      sub.save
      expect(sub.full_path).to eq "bar/"
    end

    it "updates full_path if parent directory changes name" do
      sub.reload
      sub.name = "bar"
      sub.save
      expect(sub2.reload.full_path).to eq "bar/baz/"
    end

    it "updates full_path if parent directory changes" do
      sub2.parent = root
      sub2.save
      expect(sub2.full_path).to eq "baz/"
    end
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

  context "with sibling songs" do
    before do
      Song.any_instance.stub(extract_sound_details: nil)
      FactoryGirl.create(:song, name: "baz", directory: root)
    end

    it "prevents having same name as sibling song" do
      sub.name = "baz"
      expect(sub).to_not be_valid
    end

  end

end
