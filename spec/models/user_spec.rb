require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Validations" do
    subject { User.new(password: "password", email: "foo@bar.com") }

    it_behaves_like "is valid with correct attributes"
    it_behaves_like "is not valid without required attributes", [:email, :password_digest]
  end
end
