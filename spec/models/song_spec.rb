require 'spec_helper'

describe Song do
  let!(:root) {FactoryGirl.create(:root)}
  let!(:sub) {FactoryGirl.create(:directory, name: "foo", parent: root)}
  let!(:song) {FactoryGirl.create(:song, name: "jazz", directory: sub)}

  subject { song }
  #it { should have_attached_file(:sound) }
  pending { should validate_attachment_presence(:sound) }
  #it { should validate_attachment_content_type(:sound).  allowing('audio/mp3').  rejecting('image/png', 'image/gif' 'text/plain', 'text/xml') }
  pending { should validate_attachment_size(:sound).less_than(10.megabytes) }

  it { should respond_to :name }
  its(:name) { should eq "jazz" }
  it { should respond_to :directory }
  its(:directory) { should eq sub }
  its(:full_path) { should eq "foo/jazz"}

  it "updates full_path if parent directory changes name" do
    sub.reload
    sub.name = "bax"
    sub.save
    expect(song.reload.full_path).to eq "bax/jazz"
  end

  it "updates full_path if parent directory changes" do
    sub2 = FactoryGirl.create(:directory, name: "baz", parent: sub)
    song.directory = sub2
    song.save
    expect(song.full_path).to eq "foo/baz/jazz"
  end

  pending "extracing mp3 details" do
    before do
      @file = File.new(Rails.root.join('spec', 'fixtures', 'files', 'test.mp3'))
      song.sound = @file
      song.send(:extract_sound_details) 
      song.save
    end

    after do
      @file.close
    end

    its(:title) { should eq "Kalimba" }
    its(:album) { should eq "Ninja Tuna" }
    its(:artist) { should eq "Mr. Scruff" }
    its(:duration) { should be_within(0.1).of(348.0) }

  end

  pending ".create_from_full_path" do
    before do
      @new_song = Song.create_from_full_path "a/b/c"
    end

    specify { expect(@new_song.name).to eq "c" }
    specify { expect(@new_song.directory.name).to eq "b" }
    specify { expect(@new_song.directory.parent.name).to eq "a" }
    specify { expect(@new_song.directory.parent.parent).to be_root }

  end

  context "with multiple songs" do
    before do
      FactoryGirl.create(:song, name: "baz", directory: sub, sound_fingerprint: "test_fingerprint")
    end

    it "prevents sibling with same name" do
      song.name = "baz"
      expect(song).to_not be_valid
    end

    it "allows same name if they are not siblings" do
      song.directory = root
      song.name = "baz"
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
