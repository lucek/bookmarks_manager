require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  describe "Validations" do
    subject { create(:bookmark) }

    it_behaves_like "is valid with correct attributes"
    it_behaves_like "is not valid without required attributes", [:title, :url, :site_id]
  end

  describe "#full_url" do
    let(:site) { build(:site, url: "http://google.de") }
    let(:bookmark) { build(:bookmark, site: site, url: "/abcd") }

    it "should combine site's url and own url" do
      expect(bookmark.full_url).to eq "http://google.de/abcd"
    end
  end
end
