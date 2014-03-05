require 'spec_helper'

describe SongUploader do
  let!(:root) {FactoryGirl.create(:root)}
  let!(:sub) {FactoryGirl.create(:directory, name: "foo", parent: root)}
  let!(:song) {FactoryGirl.create(:song, name: "jazz", directory: sub)}
  let!(:uploader) {SongUploader.new(song)}

  before do
    SongUploader.enable_processing = true
  end
  after do
    SongUploader.enable_processing = false
  end

  describe "extracing mp3 file details" do
    subject { song }
    before do
      @file = File.new(Rails.root.join('spec', 'fixtures', 'files', 'test.mp3'))
      uploader.store! @file
    end

    after do
      @file.close
      uploader.remove!
    end

    its(:title) { should eq "Kalimba" }
    its(:album) { should eq "Ninja Tuna" }
    its(:artist) { should eq "Mr. Scruff" }
    its(:duration) { should be_within(0.1).of(348.0) }

    its(:sound_fingerprint) { should_not be_blank }
    its(:sound_file_size) { should > (1) }
    its(:sound_content_type) { should eq "audio/mp3" }

  end

  describe "extracing ogg file details" do
    subject { song }
    before do
      @file = File.new(Rails.root.join('spec', 'fixtures', 'files', 'test.ogg'))
      uploader.store! @file
    end

    after do
      @file.close
      uploader.remove!
    end

    its(:title) { should eq "Hydrate - Kenny Beltrey" }
    its(:album) { should eq "Favorite Things" }
    its(:artist) { should eq "Kenny Beltrey" }
    its(:duration) { should be_within(0.1).of(264.0) }

    its(:sound_fingerprint) { should_not be_blank }
    its(:sound_file_size) { should > (1) }
    its(:sound_content_type) { should eq "audio/ogg" }

  end
end
