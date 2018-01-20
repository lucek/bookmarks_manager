# Basic test object
module Test
  UrlValidatable = Struct.new(:url) do
    include ActiveModel::Validations

    validates :url, url: true
  end
end

describe UrlValidator, type: :model do
  describe "#url_valid?" do
    subject { Test::UrlValidatable.new "http://google.de" }

    it { is_expected.to be_valid }

    context "not an url" do
      before do
        subject.url = "abcde"
        subject.valid?
      end

      it "should return false" do
        expect(subject.errors[:url]).to match_array('must be a valid URL')
      end
    end

    context "empty string" do
      before do
        subject.url = ""
        subject.valid?
      end

      it "should return false" do
        expect(subject.errors[:url]).to match_array('must be a valid URL')
      end
    end
  end
end
