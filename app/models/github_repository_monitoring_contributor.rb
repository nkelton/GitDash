class GithubRepositoryMonitoringContributor < ApplicationRecord
  belongs_to :github_repository_monitoring_configuration
  has_one :contributor, class_name: 'GithubRepositoryContributor', foreign_key: :github_repository_contributors_id
end
