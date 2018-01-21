require "rails_helper"

describe BookmarkParamsBuilder, type: :model do
  describe "#build_bookmark_params" do
    let(:bookmark_params) { { title: "Bookmark", url: "http://google.de/abcd", shortening: "GDE" } }

    context "site exists" do
      let(:site) { create :site, id: 999, url: "http://google.de" }
      let(:built_params) { BookmarkParamsBuilder.build_bookmark_params(site.user, bookmark_params) }

      it "should return correct bookmark params" do
        expect(built_params[:bookmark][:title]).to eq "Bookmark"
        expect(built_params[:bookmark][:url]).to eq "/abcd"
        expect(built_params[:bookmark][:shortening]).to eq "GDE"
        expect(built_params[:bookmark][:site_id]).to eq 999
      end

      it "should return params with no errors" do
        expect(built_params[:errors].count).to eq 0
      end
    end

    context "site doesn't exist" do
      let(:user) { create :user }

      context "correct URL" do
        let(:built_params) { BookmarkParamsBuilder.build_bookmark_params(user, bookmark_params) }

        it "should return correct bookmark params" do
          expect(built_params[:bookmark][:title]).to eq "Bookmark"
          expect(built_params[:bookmark][:url]).to eq "/abcd"
          expect(built_params[:bookmark][:shortening]).to eq "GDE"
        end

        it "should create new site" do
          expect(built_params[:bookmark][:site_id]).to eq Site.last.id
        end

        it "should return params with no errors" do
          expect(built_params[:errors].count).to eq 0
        end
      end

      context "with tags" do
        before do
          bookmark_params[:all_tags] = "tag1,tag2,tag3"
        end

        let(:built_params) { BookmarkParamsBuilder.build_bookmark_params(user, bookmark_params) }

        it "should include tags in built params" do
          expect(built_params[:bookmark][:all_tags]).to eq "tag1,tag2,tag3"
        end
      end

      context "incorrect URL" do
        before do
          bookmark_params[:url] = "google"
        end

        let(:built_params) { BookmarkParamsBuilder.build_bookmark_params(user, bookmark_params) }

        it "should return an error" do
          expect(built_params[:errors]).not_to be_empty
        end
      end
    end
  end
end
