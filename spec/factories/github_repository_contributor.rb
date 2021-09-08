FactoryBot.define do
  factory :github_repository_contributor do
    login { Faker::Name.name }
    sequence(:github_id).tap(&:to_s)
    association :github_repository, factory: :github_repository
    metadata { {} }
  end
end
