require 'rails_helper'

RSpec.describe Site, type: :model do
  describe "Validations" do
    subject { create(:tag) }

    it_behaves_like "is valid with correct attributes"
    it_behaves_like "is not valid without required attributes", [:name, :user_id]
  end
end
