class GithubRepositoryUpdater < BaseService

  # TODO: need to add tests for scenarios 7a4a32c8f35db489b236468fe26960194e5842d2
  def initialize(github_repository, github_repo_attrs)
    super()
    @github_repository = github_repository
    @github_repo_attrs = github_repo_attrs
    @redirect_to_monitoring_notification_config = false
  end

  attr_reader :github_repository, :github_repo_attrs

  def call
    ActiveRecord::Base.transaction do
      update_state! if aasm_state.present?
      update_config! if (monitoring_config_attrs.present? || contributors_to_monitor_attrs.present?) && !deactivate?
    end

    success([@redirect_to_monitoring_notification_config, github_repository.reload])
  end

  private

  def update_state!
    if activate?
      github_repository.activate!
      @redirect_to_monitoring_notification_config = true
    elsif deactivate?
      github_repository.deactivate!
      GithubRepositoryMonitoringNotificationConfigurationDestroyerJob.perform_later(github_repository.monitoring_configuration)
    end
  end

  def update_config!
    GithubRepositoryMonitoringConfigurationUpdaterJob.perform_later(config_data)
  end

  def config_data
    {
      monitoring_config: monitoring_config,
      notification_types: notification_types,
      contributors_to_monitor_ids: contributors_to_monitor_ids
    }
  end

  def notification_types
    monitoring_config_attrs[:notification_types].reject(&:empty?)
  end

  def monitoring_config_attrs
    @monitoring_config_attrs ||= github_repo_attrs[:monitoring_configuration_attributes]
  end

  def contributors_to_monitor_ids
    @contributors_to_monitor_ids ||= contributors_to_monitor_attrs[:ids].reject(&:empty?)
  end

  def contributors_to_monitor_attrs
    @contributors_to_monitor_attrs ||= github_repo_attrs[:contributors_to_monitor]
  end

  def monitoring_config
    @monitoring_config ||= github_repository.monitoring_configuration
  end

  def activate?
    github_repository.may_activate? && to_active?
  end

  def deactivate?
    github_repository.may_deactivate? && to_inactive?
  end

  def to_active?
    aasm_state == 'active'
  end

  def to_inactive?
    aasm_state == 'inactive'
  end

  def aasm_state
    @aasm_state ||= github_repo_attrs[:aasm_state]
  end

end
