require 'spec_helper'

describe Song do
  let!(:root) {FactoryGirl.create(:root)}
  let!(:sub) {FactoryGirl.create(:directory, name: "foo", parent: root)}
  let!(:song) {FactoryGirl.create(:song, name: "jazz", directory: sub, duration: 1234.5)}

  subject { song }

  it { should respond_to :name }
  its(:name) { should eq "jazz" }
  it { should respond_to :directory }
  its(:directory) { should eq sub }
  its(:full_path) { should eq "foo/jazz"}
  its(:duration_formated) { should eq "00:20:34"}
  it { should_not be_banned }

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

  describe "#path_search" do
    specify { expect(Song.path_search "foo").to eq song}
    specify { expect(Song.path_search "foo/").to eq song}
    specify { expect(Song.path_search "/foo").to eq song}
    specify { expect(Song.path_search "foo/jazz").to eq song}
    specify { expect(Song.path_search "").to eq song}
    specify { expect(Song.path_search "foo/nope").to be_nil}
    specify { expect(Song.path_search "fo").to be_nil}
    specify { expect(Song.path_search "nope").to be_nil}

  end

  describe ".to_s" do
    specify { expect(Song.new().to_s).to be_blank }
    specify { expect(Song.new(title: "My Title").to_s).to eq "My Title" }
    specify { expect(Song.new(title: "My Title", artist: "Bob", album: "Bob's Album").to_s).to eq "My Title - Bob" }
    specify { expect(Song.new(title: "My Title", album: "Bob's Album").to_s).to eq "My Title - Bob's Album" }
    specify { expect(Song.new(name: "bob", full_path: "g/bob").to_s).to eq "bob" }
    specify { expect(Song.new(name: "bob", full_path: "g/bob", artist: "Bob", album: "Bob's Album").to_s).to eq "bob - Bob" }
    specify { expect(Song.new(name: "bob", full_path: "g/bob", album: "Bob's Album").to_s).to eq "bob - Bob's Album" }
  end

  describe ".to_p_command" do
    specify { expect(Song.new(name: "bob", full_path: "g/bob", album: "Bob's Album").to_p_command).to eq "!p g/bob" }
  end

  describe ".to_pall_command" do
    specify { expect(Song.new(name: "bob", full_path: "g/bob", album: "Bob's Album").to_pall_command).to eq "!pall g/bob" }
  end

  it "can be banned" do
    song.banned_at = Time.now
    song.save
    song.reload
    expect(song).to be_banned
  end

  it "auto bans songs with profanity in name" do
    bad_song = FactoryGirl.create(:song, name: "fgt", directory: sub, duration: 1234.5)
    expect(bad_song).to be_banned
  end

  it "auto bans songs with profanity in filename" do
    bad_song = FactoryGirl.create(:song, name: "baz", directory: sub, duration: 1234.5, sound_file_name: "bad_filename-fgt_")
    expect(bad_song).to be_banned
  end

  it "auto bans songs with profanity in title" do
    bad_song = FactoryGirl.create(:song, name: "baz", directory: sub, duration: 1234.5, title: "FGT")
    expect(bad_song).to be_banned
  end

end
