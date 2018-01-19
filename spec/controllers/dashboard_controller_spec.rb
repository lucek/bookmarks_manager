require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  describe "#index" do
    let(:user) { create :user }

    before do
      cookies.permanent.signed[:user_id] = user.id
      get :index
    end

    it "should get index" do
      expect(response).to be_success
    end

    it "should render dashboard index page" do
      expect(response).to render_template(:index)
    end
  end
end
