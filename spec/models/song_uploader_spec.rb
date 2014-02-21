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

  describe "extracing file details" do
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

    its(:sound_fingerprint) { should_not be_nil }
    its(:sound_file_size) { should eq 11 }
    its(:sound_file_content_type) { should eq "audio/mp3" }

  end
end
