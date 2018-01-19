FactoryBot.define do
  factory :user do
    email     { "#{Faker::Zelda.character}@hyrule.com" }
    password  'vehiculum'
  end
end
