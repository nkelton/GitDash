class GithubRepositoryMonitoringConfigurationUpdaterJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: false

  def perform(monitoring_config)
    GithubRepositoryMonitoringConfigurationUpdater.new(
      monitoring_config[:monitoring_config],
      monitoring_config[:notification_types],
      monitoring_config[:contributors_to_monitor_ids]
    ).call
  end
end
