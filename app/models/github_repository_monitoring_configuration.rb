class GithubRepositoryMonitoringConfiguration < ApplicationRecord
  belongs_to :github_repository
  has_one :github_account, through: :github_repository
  has_one :github_hook, through: :github_repository
  has_many :monitoring_contributors, class_name: 'GithubRepositoryMonitoringContributor', foreign_key: :github_repository_monitoring_configuration_id

  NOTIFICATION_TYPES = %w[
    commit_comment discussion discussion_comment issue_comment
    pull_request pull_request_review pull_request_review_comment
  ].freeze

  validate :validate_notification_types

  def validate_notification_types
    return if (notification_types - NOTIFICATION_TYPES).empty?

    errors.add(:notification_types, 'one or more types invalid')
  end

end
