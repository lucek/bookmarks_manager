require 'rails_helper'

RSpec.describe TagsController, type: :controller do
  let(:user)   { create :user }

  before do
    login_user(user)
  end

  describe "#index" do
    before do
      get :index
    end

    it_behaves_like "renders index"
  end

  describe "#destroy" do
    let(:params) { { id: create(:tag, user: user).id } }

    before do
      delete :destroy, params: params
    end

    it "redirects to tags url" do
      expect(response).to be_redirect
      expect(response).to redirect_to(tags_path)
    end

    it "deletes the tag" do
      expect(Site.count).to eq 0
    end
  end
end
