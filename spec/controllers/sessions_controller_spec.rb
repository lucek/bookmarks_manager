require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe "#new" do
    before do
      get :new
    end

    it_behaves_like "renders new"
  end

  context "user has an account" do
    let(:user) { create :user }

    describe "#create" do
      let(:params) { get_login_params(user.email, user.password) }

      context "correct login data" do
        before do
          post :create, params: params
        end

        it_behaves_like "redirects to dashboard"
        it_behaves_like "displays flash message", :success, "You've been successfully logged in"
      end

      context "wrong login data" do
        before do
          params[:user][:email] = "wrongemail"
          post :create, params: params
        end

        it_behaves_like "redirects to login"
        it_behaves_like "displays flash message", :error, "Incorrect email/password"
      end
    end

    describe "#destroy" do
      before do
        login_user(user)
        get :destroy
      end

      it "should delete user_id cookie" do
        expect(request.cookies[:user_id]).to be_nil
      end

      it "should redirect to root url" do
        expect(response).to be_redirect
        expect(response).to redirect_to(login_url)
      end

      it_behaves_like "displays flash message", :success, "You've been successfully logged out"
    end
  end
end
