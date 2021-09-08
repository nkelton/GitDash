class GithubRepositoryMonitoringContributor < ApplicationRecord
  belongs_to :github_repository_monitoring_configuration
  belongs_to :contributor, class_name: 'GithubRepositoryContributor', foreign_key: :github_repository_contributors_id
end
