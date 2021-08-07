FactoryBot.define do
  factory :github_account do
    token { Faker::Alphanumeric.alpha(number: 10) }
    association :user, factory: :user
    metadata { {} }
  end
end