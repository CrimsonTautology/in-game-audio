require 'spec_helper'

describe "user theme song manager" do
  let!(:root) {FactoryGirl.create(:root)}
  subject { page }

  describe "GET /users/:id/themes" do

    context "with no themes" do
      let!(:user) {FactoryGirl.create(:user)}
      before do
        login user
        visit user_themes_path(user)
      end

      its(:status_code) { should eq 200}
    end

  end

end
