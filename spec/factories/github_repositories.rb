FactoryBot.define do
  factory :github_repository do
    name { Faker::Name.name }
    sequence(:github_id).tap(&:to_s)
    association :github_account, factory: :github_account
    metadata { {} }
  end
end
