require 'rails_helper'

RSpec.describe SignupController, type: :controller do
  describe "#new" do
    before do
      get :new
    end

    it_behaves_like "renders new"
  end

  describe "#create" do
    let(:name)   { Faker::StarWars.character }
    let(:params) { get_login_params("#{name}@galaxy.com", "password") }

    context "with correct data" do
      before do
        post :create, params: params
      end

      it "creates an user" do
        expect(User.count).to eq 1
        expect(User.last.email).to eq "#{name}@galaxy.com"
      end

      it_behaves_like "redirects to dashboard"
      it_behaves_like "displays flash message", :success, "Your account has been created"
    end

    context "with incorrect data" do
      before do
        params[:user][:email] = ""
        params[:user][:password] = ""
        post :create, params: params
      end

      it_behaves_like "renders new"
    end
  end
end
