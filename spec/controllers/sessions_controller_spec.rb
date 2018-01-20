require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe "#new" do
    before do
      get :new
    end

    it "should get index" do
      expect(response).to be_success
    end

    it "should render login page" do
      expect(response).to render_template(:new)
    end
  end

  describe "#create" do
    context "wrong login data" do
      let(:params) do
        {
          user: {
            email: "wrong@email.com",
            password: "wrong_password"
          }
        }
      end

      before do
        post :create, params: params
      end

      it "should render #new" do
        expect(response).to be_success
        expect(response).to render_template(:new)
      end

      it "should display flash message" do
        expect(flash[:error]).to eq "Incorrect email/password"
      end
    end

    context "correct login data" do
      let(:user) { create :user }
      let(:params) do
        {
          user: {
            email: user.email,
            password: user.password
          }
        }
      end

      before do
        post :create, params: params
      end

      it "should redirect to dashboard url" do
        expect(response).to be_redirect
        expect(response).to redirect_to(dashboard_url)
      end

      it "should display flash message" do
        expect(flash[:success]).to eq "You've been successfully logged in"
      end
    end
  end

  describe "#destroy" do
    before do
      request.cookies[:user_id] = 1234
      get :destroy
    end

    it "should delete user_id cookie" do
      expect(request.cookies[:user_id]).to be_nil
    end

    it "should redirect to root url" do
      expect(response).to be_redirect
      expect(response).to redirect_to(login_url)
    end

    it "should display flash message" do
      expect(flash[:success]).to eq "You've been successfully logged out"
    end
  end
end
