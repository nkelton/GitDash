class GithubRepository < ApplicationRecord
  belongs_to :github_account

  validates :github_id, uniqueness: true
  validates :name, presence: true

  METADATA_ATTRS = %w[
    html_url owner git_url private ssh_url homepage full_name
  ].freeze

  METADATA_ATTRS.each do |attribute|
    define_method attribute do
      metadata[attribute]
    end
  end

  def monitoring_message
    monitoring_notifications? ? 'Notifications are monitored' : 'Notifications are not monitored'
  end

end
