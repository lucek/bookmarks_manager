require 'rails_helper'

RSpec.describe BookmarksController, type: :controller do
  let(:user)   { create :user }
  let(:params) { get_bookmark_params }

  before do
    login_user(user)
  end

  describe "#index" do
    before do
      get :index
    end

    it_behaves_like "index examples"
  end

  describe "#create" do
    context "with correct data" do
      before do
        post :create, params: params
      end

      it "should create a bookmark" do
        expect(Bookmark.count).to eq 1
        bookmark = Bookmark.last
        expect(bookmark.title).to eq "Bookmark"
      end

      it_behaves_like "redirects to dashboard"
      it_behaves_like "displays flash message", :success, "Bookmark http://google.de/abcd has been created!"
    end

    context "with incorrect data" do
      it_behaves_like "without required attributes it redirects back to form", [:title, :url], :create
      it_behaves_like "with invalid url it redirects back to form", :create
    end

    context "with tags" do
      before do
        params[:bookmark][:all_tags] = "tag1"
      end

      context "tag doesn't exist" do
        before do
          post :create, params: params
        end

        it_behaves_like "ensures there is only one tag", "tag1"
        it_behaves_like "assigns tags to bookmark", ["tag1"], 1
      end

      context "tag exists" do
        let(:tag) { create :tag, name: "existingtag", user: user }

        before do
          params[:bookmark][:all_tags] = "existingtag"
          post :create, params: params
        end

        it_behaves_like "ensures there is only one tag", "existingtag"
        it_behaves_like "assigns tags to bookmark", ["existingtag"], 1
      end

      context "multiple tags" do
        before do
          params[:bookmark][:all_tags] = "tag1,tag2,tag3"
          post :create, params: params
        end

        it_behaves_like "assigns tags to bookmark", ["tag1", "tag2", "tag3"], 3
      end
    end
  end

  describe "#update and #destroy" do
    let(:site)     { create :site, user: user }
    let(:bookmark) { create :bookmark, site: site }

    describe "#update" do
      before do
        params[:id] = bookmark.id
      end

      context "with correct data" do
        before do
          post :update, params: params
        end

        it_behaves_like "redirects to dashboard"

        it "updates bookmark" do
          expect(bookmark.reload.title).to eq "Bookmark"
        end

        it "displays flash message" do
          expect(flash[:success]).to eq "Bookmark has been updated!"
        end
      end

      context "with incorrect data" do
        it_behaves_like "without required attributes it redirects back to form", [:title, :url], :update
        it_behaves_like "with invalid url it redirects back to form", :update
      end
    end

    describe "#destroy" do
      let(:params) { { id: bookmark.id } }

      before do
        delete :destroy, params: params
      end

      it_behaves_like "redirects to dashboard"

      it "deletes the bookmark" do
        expect(Bookmark.count).to eq 0
      end
    end
  end
end
