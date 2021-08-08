FactoryBot.define do
  factory :github_repository_monitoring_configuration do
    association :github_repository, factory: :github_repository
    notification_types { [] }
  end
end
