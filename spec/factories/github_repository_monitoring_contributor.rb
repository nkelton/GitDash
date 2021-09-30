FactoryBot.define do
  factory :github_repository_monitoring_contributor do
    association :github_repository_monitoring_configuration, factory: :github_repository_monitoring_configuration
    association :contributor, factory: :github_repository_contributor
  end
end
