require 'spec_helper'

describe "Song Directories" do
  subject { page }

  describe "GET /directories/:full_path" do
    let!(:root) {FactoryGirl.create(:root)}
    let!(:sub) {FactoryGirl.create(:directory, name: "foo", parent: root)}

    before do
      visit "/directories/#{root.full_path}"
    end

    its(:status_code) { should eq 200}
    it { should have_link(sub.full_path, href: directory_path(sub))}

    pending "subdirectories" do
      let!(:sub2) {FactoryGirl.create(:directory, name: "bar", parent: sub)}
      let!(:sub3) {FactoryGirl.create(:directory, name: "baz", parent: sub2)}
      before do
        click_on sub.full_path
        click_on sub2.full_path
      end

      its(:status_code) { should eq 200}
      it { should have_link(sub3.full_path, href: directory_path(sub3))}
    end
  end
end
