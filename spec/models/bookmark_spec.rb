require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  subject { create(:bookmark) }

  describe "Validations" do
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
end
