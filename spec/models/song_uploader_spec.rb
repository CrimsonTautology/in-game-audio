require 'spec_helper'

describe SongUploader do
  let!(:root) {FactoryGirl.create(:root)}
  let!(:sub) {FactoryGirl.create(:directory, name: "foo", parent: root)}
  let!(:song) {FactoryGirl.create(:song, name: "jazz", directory: sub)}
  let!(:uploader) {SongUploader.new(song)}

  before do
    SongUploader.enable_processing = true
    SongUploader.any_instance.stub(:convert_to_ogg).and_return(nil)
    SongUploader.any_instance.stub(:convert_to_mp3).and_return(nil)
  end
  after do
    SongUploader.enable_processing = false
    CarrierWave.clean_cached_files!
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
    its(:sound_content_type) { should eq "audio/mpeg" }

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

  describe "extracing wav file details" do
    subject { song }
    before do
      @file = File.new(Rails.root.join('spec', 'fixtures', 'files', 'test.wav'))
      uploader.store! @file
    end

    after do
      @file.close
      uploader.remove!
    end

    its(:title) { should be_nil }
    its(:album) { should be_nil }
    its(:artist) { should be_nil }
    its(:duration) { should be_within(0.1).of(6.3) }

    its(:sound_fingerprint) { should_not be_blank }
    its(:sound_file_size) { should > (1) }
    its(:sound_content_type) { should eq "audio/x-wav" }

  end

  describe "extracing non-standard wav file details" do
    subject { song }
    before do
      @file = File.new(Rails.root.join('spec', 'fixtures', 'files', 'its electric.wav'))
      uploader.store! @file
    end

    after do
      @file.close
      uploader.remove!
    end

    its(:title) { should be_nil }
    its(:album) { should be_nil }
    its(:artist) { should be_nil }
    its(:duration) { should be_within(0.1).of(2.4) }

    its(:sound_fingerprint) { should_not be_blank }
    its(:sound_file_size) { should > (1) }
    its(:sound_content_type) { should eq "audio/x-wav" }

  end
end
