require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  describe "Validations" do
    subject { create(:bookmark) }

    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is valid without shortening" do
      subject.shortening = nil
      expect(subject).to be_valid
    end

    it "is not valid without a title" do
      subject.title = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without an url" do
      subject.url = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without an site_id" do
      subject.site_id = nil
      expect(subject).to_not be_valid
    end
  end

  describe "#full_url" do
    let(:site) { build(:site, url: "http://google.de") }
    let(:bookmark) { build(:bookmark, site: site, url: "/abcd") }

    it "should combine site's url and own url" do
      expect(bookmark.full_url).to eq "http://google.de/abcd"
    end
  end
end
