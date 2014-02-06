require 'spec_helper'

describe Song do
  let!(:root) {FactoryGirl.create(:root)}
  let!(:sub) {FactoryGirl.create(:directory, name: "foo", parent: root)}

  before do
    @song = Song.new
    @song.name = "jazz"
    @song.directory = sub
  end
  subject { @song }
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
      @song.sound = @file
      @song.send(:extract_sound_details) 
    end

    after do
      @file.close
    end

    its(:title) { should eq "Kalimba" }
    its(:album) { should eq "Ninja Tuna" }
    its(:artist) { should eq "Mr. Scruff" }
    its(:duration) { should be_within(0.1).of(348.0) }
  end


  it "prevents multiple sibling songs of the same name" do
    Song.any_instance.stub(extract_sound_details: nil)
    FactoryGirl.create(:song, name: "baz", directory: sub)
    @song.name = "bAz"
    expect(@song).to_not be_valid
  end
end
