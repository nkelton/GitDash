FactoryBot.define do
  factory :github_pull_request do
    title { Faker::Movie.title }
    sequence(:github_id).tap(&:to_s)
    body { Faker::Movie.quote }
    state { Faker::Quote.famous_last_words }
    association :github_repository, factory: :github_repository
    metadata { {} }
  end
end
