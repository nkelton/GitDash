class GithubRepositoryUpdater < BaseService

  def initialize(github_repository, github_repo_attrs)
    super()
    @github_repository = github_repository
    @github_repo_attrs = github_repo_attrs
  end

  def call
    if aasm_state.present?
      if activate?
        @github_repository.activate!
        redirect_to_monitoring_notification_config = true
      elsif deactivate?
        @github_repository.deactivate!
        GithubRepositoryMonitoringNotificationConfigurationDestroyerJob.perform_later(@github_repository.monitoring_configuration)
        redirect_to_monitoring_notification_config = false
      end

      return success([redirect_to_monitoring_notification_config, @github_repository.reload])
    end

    success
  end

  private

  def activate?
    @github_repository.may_activate? && to_active?
  end

  def deactivate?
    @github_repository.may_deactivate? && to_inactive?
  end

  def to_active?
    aasm_state == 'active'
  end

  def to_inactive?
    aasm_state == 'inactive'
  end

  def aasm_state
    @aasm_state ||= @github_repo_attrs[:aasm_state]
  end

end
