require 'spec_helper'

describe "Song Directories" do
  subject { page }

  shared_examples_for "a directory page" do
    its(:status_code) { should eq 200}
    it { should have_content(directory.full_path)}

    it { should_not have_link("Edit this directory", edit_directory_path(directory)) }
    it { should_not have_link("Create new directory", new_directory_path) }
    it { should_not have_link("Delete this directory", directory_path(directory)) }

    context "with songs" do
      let!(:song) {FactoryGirl.create(:song, name: "fatbeats", directory: directory)}

      before do
        visit directory_path(directory)
      end

      it { should have_link(song.name, href: song_path(song))}
      it { should_not have_link("Edit", edit_song_path(song)) }
      it { should_not have_link("Play", play_song_path(song)) }

      context "as admin" do
        before do
          login FactoryGirl.create(:admin)
          visit directory_path(directory)
        end

        it { should have_link("", edit_song_path(song)) }
        it { should have_link("", play_song_path(song)) }
      end
    end

    context "with subdirectories" do
      let!(:sub2) {FactoryGirl.create(:directory, name: "foo", parent: directory, description: "Foo Files")}
      before do
        visit directory_path(directory)
      end

      it { should have_link(sub2.path_name, href: directory_path(sub2))}
      it { should have_content(sub2.description)}

    end
  end

  shared_examples_for "a root directory page" do
    it_behaves_like "a directory page"

    specify { expect(directory).to be_root }
    it { should_not have_link("..") }

    context "as admin" do
      before do
        login FactoryGirl.create(:admin)
        visit directory_path(directory)
      end

      it { should_not have_link("Edit this directory", edit_directory_path(directory)) }
      it { should have_link("Create new directory", new_directory_path) }
      it { should_not have_link("Delete this directory", directory_path(directory)) }
    end
  end

  shared_examples_for "a sub-directory page" do
    it_behaves_like "a directory page"

    specify { expect(directory).to_not be_root }

    it { should have_link("..", href: directory_path(directory.parent))}

    context "as admin" do
      before do
        login FactoryGirl.create(:admin)
        visit directory_path(directory)
      end

      it { should have_link("Edit this directory", edit_directory_path(directory)) }
      it { should have_link("Create new directory", new_directory_path) }
      it { should_not have_link("Delete this directory", directory_path(directory)) }
    end
  end

  describe "GET /directories" do
    let!(:root) {FactoryGirl.create(:root)}

    before do
      visit "/directories"
    end

    it_behaves_like "a root directory page" do
      let!(:directory) { root }
    end
  end

  describe "GET /directories/:id" do
    let!(:root) {FactoryGirl.create(:root)}
    let!(:sub) {FactoryGirl.create(:directory, name: "foo", parent: root, description: "Foo Files")}

    before do
      visit "/directories/#{sub.id}"
    end

    it_behaves_like "a sub-directory page" do
      let!(:directory) { sub }
    end

  end

  describe "GET /directories/new" do
    let!(:root) {FactoryGirl.create(:root)}
    let!(:sub) {FactoryGirl.create(:directory, name: "foo", parent: root, description: "Foo Files")}

    context "not authorized" do
      before do
        visit "/directories/new"
      end

      its(:status_code) { should eq 403}
    end

    context "as admin" do
      before do
        login FactoryGirl.create(:admin)
        visit "/directories/new"
      end

      its(:status_code) { should eq 200}

      describe "creating new directory" do
        before do
          #raise page.body.to_yaml
          fill_in "Name", with: "newname"
          fill_in "Description", with: "this is a description"
          select "foo/", from: "Parent"
          click_on "Create Directory"
        end

        specify{ expect(Directory.find_by(full_path: "foo/newname/")).to_not be_nil }
        specify{ expect(Directory.find_by(full_path: "foo/newname/").description).to eq "this is a description" }

      end
    end
  end

  describe "GET /directories/:id/edit" do
    let!(:root) {FactoryGirl.create(:root)}
    let!(:sub) {FactoryGirl.create(:directory, name: "foo", parent: root, description: "Foo Files")}
    let!(:sub2) {FactoryGirl.create(:directory, name: "bar", parent: sub)}
    let!(:song) {FactoryGirl.create(:song, name: "fatbeats", directory: sub2)}

    context "not authorized" do
      before do
        visit "/directories/#{sub.id}/edit"
      end

      its(:status_code) { should eq 403}
    end

    context "as admin" do
      before do
        login FactoryGirl.create(:admin)
        visit "/directories/#{sub.id}/edit"
      end

      its(:status_code) { should eq 200}

      describe "editing directory" do
        before do
          #raise page.body.to_yaml
          fill_in "Name", with: "newname"
          fill_in "Description", with: "this is a description"
          click_on "Update Directory"
          sub.reload
          sub2.reload
          song.reload
        end

        specify { expect(sub.full_path).to eq "newname/"}
        specify { expect(sub.description).to eq "this is a description"}
        specify { expect(sub2.full_path).to eq "newname/bar/"}
        specify { expect(song.full_path).to eq "newname/bar/fatbeats"}


      end
    end
  end

end
