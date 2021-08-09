FactoryBot.define do
  factory :github_hook do
    sequence(:github_id).tap(&:to_s)
    association :github_repository_monitoring_configuration, factory: :github_repository_monitoring_configuration
    metadata { {} }
  end
end
