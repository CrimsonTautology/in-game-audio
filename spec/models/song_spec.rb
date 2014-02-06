require 'spec_helper'

describe Song do
  let!(:root) {FactoryGirl.create(:root)}
  let!(:sub) {FactoryGirl.create(:directory, name: "foo", parent: root)}
  let(:song) {FactoryGirl.build(:song, name: "jazz", directory: sub)}

  subject { song }
  it { should have_attached_file(:sound) }
  pending { should validate_attachment_presence(:sound) }
  it { should validate_attachment_content_type(:sound).
                allowing('audio/mp3').
                rejecting('image/png', 'image/gif' 'text/plain', 'text/xml') }
  pending { should validate_attachment_size(:sound).less_than(10.megabytes) }

  it { should respond_to :name }
  its(:name) { should eq "jazz" }
  it { should respond_to :directory }
  its(:directory) { should eq sub }

  describe "#extract_sound_details" do
    before do
      @file = File.new(Rails.root.join('spec', 'songs', 'test.mp3'))
      song.sound = @file
      song.send(:extract_sound_details) 
    end

    after do
      @file.close
    end

    its(:title) { should eq "Kalimba" }
    its(:album) { should eq "Ninja Tuna" }
    its(:artist) { should eq "Mr. Scruff" }
    its(:duration) { should be_within(0.1).of(348.0) }
  end

  context "with multiple songs" do
    before do
      Song.any_instance.stub(extract_sound_details: nil)
      FactoryGirl.create(:song, name: "baz", directory: sub, sound_fingerprint: "test_fingerprint")
    end

    it "prevents sibling with same name" do
      song.name = "bAz"
      expect(song).to_not be_valid
    end

    it "allows same name if they are not siblings" do
      song.directory = root
      song.name = "bAz"
      expect(song).to be_valid
    end

    it "prevents same file from beign uploaded twice" do
      song.sound_fingerprint = "test_fingerprint"
      expect(song).to_not be_valid
    end

  end

  it "prevents a song from having same name as sibling directory" do
    FactoryGirl.create(:directory, name: "bar", parent: sub)
    song.directory = sub
    song.name = "bar"
    expect(song).to_not be_valid
  end
end
