require 'spec_helper'

describe "Song Directories" do
  subject { page }

  shared_examples_for "a directory page" do
    its(:status_code) { should eq 200}
    it { should have_content(directory.full_path)}
    it { should have_link("", new_song_path) }
  end

  describe "GET /directories" do
    let!(:root) {FactoryGirl.create(:root)}

    before do
      visit "/directories"
    end

    it_behaves_like "a directory page" do
      let!(:directory) { root }
    end
  end

  describe "GET /directories/:id" do
    let!(:root) {FactoryGirl.create(:root)}

    before do
      visit "/directories/#{root.id}"
    end

    it_behaves_like "a directory page" do
      let!(:directory) { root }
    end

    context "with subdirectories" do
      let!(:sub) {FactoryGirl.create(:directory, name: "foo", parent: root)}
      before do
        visit current_path
      end

      it_behaves_like "a directory page" do
        let(:directory) { root }
      end
      it { should have_link(sub.path_name, href: directory_path(sub))}

      describe "visiting subdirectories" do
        let!(:sub2) {FactoryGirl.create(:directory, name: "bar", parent: sub)}
        let!(:sub3) {FactoryGirl.create(:directory, name: "baz", parent: sub2)}
        before do
          visit current_path
          click_on sub.path_name
          click_on sub2.path_name
        end

        it_behaves_like "a directory page" do
          let(:directory) { sub2 }
        end
        it { should have_link(sub3.path_name, href: directory_path(sub3))}
        it { should have_link("..", href: directory_path(sub2.parent))}

      end
    end

    context "with songs" do
      let!(:song) {FactoryGirl.create(:song, name: "fatbeats", directory: root)}

      before do
        visit current_path
      end

      it_behaves_like "a directory page" do
        let(:directory) { root }
      end
      it { should have_link(song.name, href: song_path(song))}

      describe "visiting songs" do
        before do
          click_on song.name
        end
        its(:status_code) { should eq 200}
        it { should have_content(song.full_path)}

      end
    end
  end
end
