class GithubRepositoryMonitoringConfigurationCreator < BaseService

  # TODO: need to add tests for scenarios d0b97157b69945767f1eb4da954f649479a20a5f
  def initialize(monitoring_configuration_params)
    super()
    @monitoring_configuration = GithubRepositoryMonitoringConfiguration.new(
      monitoring_configuration_params.except(:contributors_to_monitor)
    )
    @contributors_to_monitor = monitoring_configuration_params[:contributors_to_monitor]
  end

  def call
    unless @monitoring_configuration.valid?
      add_error(@monitoring_configuration.errors)
      return failure
    end

    ActiveRecord::Base.transaction do
      @monitoring_configuration.save!
      if @contributors_to_monitor.present? && @contributors_to_monitor.key?(:ids)
        @contributors_to_monitor[:ids].each do |contributor_id|
          contributor = GithubRepositoryContributor.find_by_id(contributor_id)
          # skip if the contributor doesn't exist in our db
          next unless contributor.present?

          @monitoring_configuration.monitoring_contributors.create!(
            github_repository_contributors_id: contributor.id
          )
        end
      end
    end

    GithubHookCreatorJob.perform_later(@monitoring_configuration)

    success(@monitoring_configuration)
  end

end
