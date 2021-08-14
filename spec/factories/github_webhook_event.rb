FactoryBot.define do
  factory :github_webhook_event do
    type { Faker::Music.genre }
    action { Faker::Music.chord }
    metadata { {} }
    association :github_hook, factory: :github_hook
  end
end
