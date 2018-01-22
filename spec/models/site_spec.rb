require 'rails_helper'

RSpec.describe Site, type: :model do
  describe "Validations" do
    subject { create(:site) }

    it_behaves_like "is valid with correct attributes"
    it_behaves_like "is not valid without required attributes", [:url]

    ["http://", "http://google", "google"].each do |bad_url|
      it "is not valid with bad url - #{bad_url}" do
        subject[:url] = bad_url
        expect(subject).to_not be_valid
      end
    end

    ["http://google.com", "https://google.com"].each do |url|
      it "is valid with correct url - #{url}" do
        subject[:url] = url
        expect(subject).to be_valid
      end
    end
  end

  describe "adding protocol" do
    context "there is no protocol specified" do
      subject { create :site, url: "subject.com"}

      it "adds http" do
        subject.validate
        expect(subject.reload.url).to eq "http://subject.com"
      end
    end

    context "there is protocol specified" do
      context "https" do
        subject { build :site, url: "http://subject.com"}

        it "does not add http when there is http/https protocol specified" do
          subject.validate
          expect(subject.url).to eq "http://subject.com"
        end
      end

      context "https" do
        subject { build :site, url: "https://subject.com"}

        it "does not add http when there is http/https protocol specified" do
          subject.validate
          expect(subject.url).to eq "https://subject.com"
        end
      end
    end
  end
end
