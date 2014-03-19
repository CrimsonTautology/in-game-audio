require 'spec_helper'

describe "user theme song manager" do
  let!(:user) {FactoryGirl.create(:user)}

  subject { page }

  describe "GET /users/:id" do
    before do
      visit user_path(user)
    end

    its(:status_code) { should eq 200}
  end
end
