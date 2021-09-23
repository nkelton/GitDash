class GithubRepositoryMonitoringConfigurationUpdater < BaseService

  NAME = 'web'.freeze
  URL = "http://#{ENV['NGROK_HOST']}/github_webhooks/payload".freeze

  def initialize(github_monitoring_configuration, notification_types, contributors_to_monitor)
    super()
    @github_monitoring_configuration = github_monitoring_configuration
    @notification_types = notification_types
    @contributors_to_monitor = contributors_to_monitor
  end

  attr_reader :github_monitoring_configuration, :notification_types, :contributors_to_monitor

  def call
    # TODO: if we dont need to update the hook with github we don't need to udpate here
    updated_hook = update_github_hook!

    ActiveRecord::Base.transaction do
      github_hook.update!(metadata: updated_hook.to_hash)
      github_monitoring_configuration.update!(notification_types: notification_types)
      update_contributors_to_monitor! if contributors_to_monitor.any?
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

  def update_contributors_to_monitor!
    add_monitoring_contributors!
    remove_monitoring_contributors!
  end

  def add_monitoring_contributors!
    add_monitoring_contributor_ids.each do |contributor_id|
      contributor = GithubRepositoryContributor.find_by_id(contributor_id)
      # skip if the contributor doesn't exist in our db
      next unless contributor.present?

      github_monitoring_configuration.monitoring_contributors.create!(
        github_repository_contributors_id: contributor.id
      )
    end
  end

  def remove_monitoring_contributors!
    remove_monitoring_contributor_ids.each do |contributor_id|
      monitoring_contributor = github_monitoring_configuration.monitoring_contributors.find_by(github_repository_contributors_id: contributor_id)
      # skip if the monitoring_contributor doesn't exist in our db
      next unless monitoring_contributor.present?

      monitoring_contributor.delete
    end
  end

  def add_monitoring_contributor_ids
    @add_monitoring_contributor_ids ||= contributors_to_monitor - monitoring_contributor_ids
  end

  def remove_monitoring_contributor_ids
    @remove_monitoring_contributor_ids ||= monitoring_contributor_ids - contributors_to_monitor
  end

  def monitoring_contributor_ids
    @monitoring_contributor_ids ||= github_monitoring_configuration.monitoring_contributors.pluck(:github_repository_contributors_id).map(&:to_s)
  end

  def monitoring_contributors
    @monitoring_contributors ||= github_monitoring_configuration.monitoring_contributors
  end

end
