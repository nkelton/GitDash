class GithubRepositoryMonitoringConfigurationUpdater < BaseService

  NAME = 'web'.freeze
  URL = "http://#{ENV['NGROK_HOST']}/github_webhooks/payload".freeze

  def initialize(github_monitoring_configuration, notification_types)
    super()
    @github_monitoring_configuration = github_monitoring_configuration
    @notification_types = notification_types
  end

  attr_reader :github_monitoring_configuration, :notification_types

  def call
    updated_hook = update_github_hook!

    ActiveRecord::Base.transaction do
      github_hook.update!(metadata: updated_hook.to_hash)
      github_monitoring_configuration.update!(notification_types: notification_types)
    end

    success(github_monitoring_configuration.reload)
  end

  private

  # http://octokit.github.io/octokit.rb/Octokit/Client/Hooks.html#edit_hook-instance_method
  def update_github_hook!
    client.edit_hook(
      repository.github_id,
      github_hook.github_id,
      NAME,
      config,
      options
    )
  end

  def github_hook
    @github_hook ||= github_monitoring_configuration.github_hook
  end

  def client
    Octokit::Client.new(
      access_token: access_token
    )
  end

  def access_token
    github_monitoring_configuration.github_account.token
  end

  def repository
    @repository ||= github_monitoring_configuration.github_repository
  end

  def config
    {
      url: URL,
      content_type: 'json'
    }
  end

  def options
    {
      active: true
    }.tap do |hash|
      hash[:add_events] = add_events if add_events?
      hash[:remove_events] = remove_events if remove_events?
    end
  end

  def add_events
    @add_events ||= notification_types - github_monitoring_configuration.notification_types
  end

  def remove_events
    @remove_events ||= github_monitoring_configuration.notification_types - notification_types
  end

  def add_events?
    add_events.any?
  end

  def remove_events?
    remove_events.any?
  end

end
