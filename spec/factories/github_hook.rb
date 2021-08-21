FactoryBot.define do
  factory :github_hook do
    sequence(:github_id).tap(&:to_s)
    association :github_repository, factory: :github_repository
    metadata { {} }
  end
end
