require 'spec_helper'

describe Song do
  let!(:root) {FactoryGirl.create(:root)}
  let!(:sub) {FactoryGirl.create(:directory, name: "foo", parent: root)}

  before do
    @song = Song.new(name: "jazz")
    @song.directory = sub
    @file = File.new(Rails.root.join('spec', 'songs', 'test.mp3'))
    @song.sound = @file
  end

  after do
    @file.close
  end

  subject { @song }
  it { should have_attached_file(:sound) }
  #it { should validate_attachment_presence(:sound) }
  it { should validate_attachment_content_type(:sound).
                allowing('audio/mp3').
                rejecting('image/png', 'image/gif' 'text/plain', 'text/xml') }
  #it { should validate_attachment_size(:sound).less_than(10.megabytes) }
  it { should respond_to :name }
  it { should respond_to :directory }
  its(:directory) { should eq sub}

  pending "validations" do
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
