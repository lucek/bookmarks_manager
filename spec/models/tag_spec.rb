require 'rails_helper'

RSpec.describe Site, type: :model do
  subject { create(:tag) }

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without an url" do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without an user_id" do
      subject.user_id = nil
      expect(subject).to_not be_valid
    end
  end
end
