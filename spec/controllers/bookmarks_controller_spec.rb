require 'rails_helper'

RSpec.describe BookmarksController, type: :controller do
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

  describe "#create" do
    let(:user) { create :user }

    context "with correct data" do
      let(:params) do
        {
          bookmark: {
            title: "Bookmark",
            url: "http://google.de/abcd",
            shortening: "BKK",
            all_tags: ""
          }
        }
      end

      before do
        cookies.permanent.signed[:user_id] = user.id
        post :create, params: params
      end

      it "should create a bookmark" do
        expect(Bookmark.count).to eq 1
        bookmark = Bookmark.last
        expect(bookmark.title).to eq "Bookmark"
      end

      it "should redirect to dashboard url" do
        expect(response).to be_redirect
        expect(response).to redirect_to(dashboard_url)
      end

      it "should display flash message" do
        expect(flash[:success]).to eq "Bookmark http://google.de/abcd has been created!"
      end
    end

    context "with incorrect data" do
      let(:params) do
        {
          bookmark: {
            title: "Bookmark",
            url: "http://google.de/abcd",
            shortening: "BKK",
            all_tags: ""
          }
        }
      end

      before do
        cookies.permanent.signed[:user_id] = user.id
      end

      context "without title" do
        before do
          params[:bookmark][:title] = nil
          post :create, params: params
        end

        it "should render #new" do
          expect(response).to be_redirect
          expect(response).to redirect_to(new_bookmark_path)
        end
      end

      context "without url" do
        before do
          params[:bookmark][:url] = nil
          post :create, params: params
        end

        it "should render #new" do
          expect(response).to be_redirect
          expect(response).to redirect_to(new_bookmark_path)
        end
      end

      context "with invalid url" do
        before do
          params[:bookmark][:url] = "abcdef"
          post :create, params: params
        end

        it "should render #new" do
          expect(response).to be_redirect
          expect(response).to redirect_to(new_bookmark_path)
        end
      end
    end

    context "with tags" do
      let(:params) do
        {
          bookmark: {
            title: "Bookmark",
            url: "http://google.de/abcd",
            shortening: "BKK",
            all_tags: "tag1"
          }
        }
      end

      before do
        cookies.permanent.signed[:user_id] = user.id
      end

      context "tag doesn't exist" do
        before do
          post :create, params: params
        end

        it "should create new tag" do
          expect(Tag.count).to eq 1
          expect(Tag.last.name).to eq "tag1"
        end

        it "should assign tag to created bookmark" do
          expect(Bookmark.last.tags.count).to eq 1
          expect(Bookmark.last.tags.map(&:name)).to eq ["tag1"]
        end
      end

      context "tag exists" do
        let(:tag) { create :tag, user: user }

        before do
          post :create, params: params
        end

        it "should not create any new tag" do
          expect(Tag.count).to eq 1
        end

        it "should assign tag to created bookmark" do
          expect(Bookmark.last.tags.count).to eq 1
          expect(Bookmark.last.tags.map(&:name)).to eq ["tag1"]
        end
      end

      context "multiple tags" do
        before do
          params[:bookmark][:all_tags] = "tag1,tag2,tag3"
          post :create, params: params
        end

        it "should assign tags to created bookmark" do
          expect(Bookmark.last.tags.count).to eq 3
          expect(Bookmark.last.tags.map(&:name)).to eq ["tag1", "tag2", "tag3"]
        end
      end
    end
  end

  describe "#update" do
    let(:bookmark) { create :bookmark }

    context "with correct data" do
      let(:params) do
        {
          id: bookmark.id,
          bookmark: {
            title: "Bookmark",
            url: "http://google.de/abcd",
            shortening: "BKK",
            all_tags: ""
          }
        }
      end

      before do
        cookies.permanent.signed[:user_id] = bookmark.user.id
        post :update, params: params
      end

      it "should update bookmark" do
        expect(bookmark.reload.title).to eq "Bookmark"
      end

      it "should redirect to dashboard url" do
        expect(response).to be_redirect
        expect(response).to redirect_to(dashboard_url)
      end

      it "should display flash message" do
        expect(flash[:success]).to eq "Bookmark has been updated!"
      end
    end

    context "with incorrect data" do
      let(:params) do
        {
          id: bookmark.id,
          bookmark: {
            title: "Bookmark",
            url: "http://google.de/abcd",
            shortening: "BKK",
            all_tags: ""
          }
        }
      end

      before do
        cookies.permanent.signed[:user_id] = bookmark.user.id
      end

      context "without title" do
        before do
          params[:bookmark][:title] = nil
          post :update, params: params
        end

        it "should render #edit" do
          expect(response).to be_redirect
          expect(response).to redirect_to(edit_bookmark_path)
        end
      end

      context "without url" do
        before do
          params[:bookmark][:url] = nil
          post :update, params: params
        end

        it "should render #new" do
          expect(response).to be_redirect
          expect(response).to redirect_to(edit_bookmark_path)
        end
      end

      context "with invalid url" do
        before do
          params[:bookmark][:url] = "abcdef"
          post :update, params: params
        end

        it "should render #new" do
          expect(response).to be_redirect
          expect(response).to redirect_to(edit_bookmark_path)
        end
      end
    end
  end

  describe "#destroy" do
    let(:bookmark) { create :bookmark }
    let(:params) { { id: bookmark.id } }

    before do
      cookies.permanent.signed[:user_id] = bookmark.user.id
      delete :destroy, params: params
    end

    it "should redirect to dashboard url" do
      expect(response).to be_success
      expect(response).to render_template(:index)
    end
  end
end
