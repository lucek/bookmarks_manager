FactoryBot.define do
  factory :user do
    email     { "#{Faker::Zelda.character}@hyrule.com" }
    password  'vehiculum'
  end

  factory :site do
    url "http://google.de"
    association :user, factory: :user
  end

  factory :bookmark do
    title "Search"
    shortening "GDE"
    url "/search"
    association :site, factory: :site
  end

  factory :tag do
    name "tag1"
    association :user, factory: :user
  end
end
