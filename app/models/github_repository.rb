class GithubRepository < ApplicationRecord
  include AASM

  belongs_to :github_account

  has_one :monitoring_configuration, class_name: 'GithubRepositoryMonitoringConfiguration', foreign_key: :github_repository_id
  has_many :webhook_events, class_name: 'GithubWebhookEvent'

  validates :github_id, uniqueness: true
  validates :name, presence: true

  METADATA_ATTRS = %w[
    html_url owner git_url private ssh_url homepage full_name
  ].freeze

  aasm do
    state :inactive, initial: true
    state :active

    event :activate do
      transitions from: :inactive, to: :active
    end

    event :deactivate do
      transitions from: :active, to: :inactive
    end
  end

  METADATA_ATTRS.each do |attribute|
    define_method attribute do
      metadata[attribute]
    end
  end

  def monitoring_message
    active? ? 'Notifications are monitored' : 'Notifications are not monitored'
  end

end
