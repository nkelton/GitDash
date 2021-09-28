class GithubRepositoryMonitoringNotificationConfigurationDestroyer < BaseService

  # TODO: need to add tests for scenarios 881a9d38b27a52c9419c407e723600571c3471dc
  def initialize(monitoring_config)
    super()
    @monitoring_config = monitoring_config
  end

  def call
    return failure(nil) if @monitoring_config.nil?

    remove_hook_from_github! if github_hook.present?

    ActiveRecord::Base.transaction do
      github_hook_events.each(&:delete) if github_hook_events.any?
      github_hook.delete if github_hook.present?
      monitoring_contributors.each(&:delete) if monitoring_contributors.any?
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
    @github_hook ||= @monitoring_config&.github_hook
  end

  def github_hook_events
    @github_hook_events ||= github_hook&.events
  end

  def monitoring_contributors
    @monitoring_contributors ||= @monitoring_config&.monitoring_contributors
  end

end
