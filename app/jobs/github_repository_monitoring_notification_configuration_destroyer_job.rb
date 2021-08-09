class GithubRepositoryMonitoringNotificationConfigurationDestroyerJob < ApplicationJob
  queue_as :default

  def perform(monitoring_config)
    GithubRepositoryMonitoringNotificationConfigurationDestroyer.new(monitoring_config).call
  end
end
