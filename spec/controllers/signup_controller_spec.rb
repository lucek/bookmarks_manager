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
      name = Faker::StarWars.character

      let(:params) do
        {
          user: {
            email: "#{name}@galaxy.com",
            password: "password"
          }
        }
      end

      before do
        post :create, params: params
      end

      it "should create an user" do
        expect(User.count).to eq 1
        user = User.last
        expect(user.email).to eq "#{name}@galaxy.com"
      end

      it "should redirect to dashboard url" do
        expect(response).to be_redirect
        expect(response).to redirect_to(dashboard_url)
      end
    end
  end
end
