class GithubHook < ApplicationRecord
  belongs_to :github_repository_monitoring_configuration
  has_one :github_repository, through: :github_repository_monitoring_configuration

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
