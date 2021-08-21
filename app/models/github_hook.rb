class GithubHook < ApplicationRecord
  belongs_to :github_repository
  has_one :github_repository_monitoring_configuration, through: :github_repository
  has_many :events, class_name: 'GithubHookEvent'

  def active?
    metadata['active']
  end

  def config
    metadata['config']
  end

  def last_response
    metadata['last_response']
  end

end
