require 'rails_helper'

RSpec.describe SignupController, type: :controller do
  describe "#new" do
    before do
      get :new
    end

    it "should get index" do
      expect(response).to be_success
    end

    it "should render signup page" do
      expect(response).to render_template(:new)
    end
  end

  describe "#create" do
    context "with incorrect data" do
      let(:params) do
        {
          user: {
            email: "",
            password: ""
          }
        }
      end

      it "should render #new" do
        post :create, params: params
        expect(response).to be_success
        expect(response).to render_template(:new)
      end
    end

    context "with correct data" do
      let(:params) do
        {
          user: {
            email: "#{Faker::StarWars.character}@galaxy.com",
            password: "password"
          }
        }
      end

      it "should redirect to dashboard url" do
        post :create, params: params
        expect(response).to be_redirect
        expect(response).to redirect_to(dashboard_url)
      end
    end
  end
end
