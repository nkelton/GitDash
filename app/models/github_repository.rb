class GithubRepository < ApplicationRecord
  include AASM

  belongs_to :github_account

  has_one :monitoring_configuration, class_name: 'GithubRepositoryMonitoringConfiguration'
  has_one :github_hook
  has_many :github_hook_events, class_name: 'GithubHookEvent', through: :github_hook
  has_many :pull_requests, class_name: 'GithubPullRequest'

  scope :monitoring, -> { where(aasm_state: 'active') }
  scope :not_monitoring, -> { where(aasm_state: 'inactive')}

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
