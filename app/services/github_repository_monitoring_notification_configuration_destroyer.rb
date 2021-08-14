class GithubRepositoryMonitoringNotificationConfigurationDestroyer < BaseService

  def initialize(monitoring_config)
    super()
    @monitoring_config = monitoring_config
  end

  def call
    remove_hook_from_github! if github_hook.present?

    ActiveRecord::Base.transaction do
      github_hook.delete if github_hook.present?
      @monitoring_config.delete
    end

    success
  end

  def remove_hook_from_github!
    client.remove_hook(
      @monitoring_config.github_repository.github_id,
      github_hook.github_id
    )
  end

  def client
    Octokit::Client.new(
      access_token: access_token
    )
  end

  def access_token
    @monitoring_config.github_account.token
  end

  def github_hook
    @github_hook ||= @monitoring_config.github_hook
  end

end