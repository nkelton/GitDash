class GithubRepositoryMonitoringConfigurationCreator < BaseService

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
      @contributors_to_monitor[:ids].each do |contributor_id|
        contributor = GithubRepositoryContributor.find_by_id(contributor_id)
        next unless contributor.present? #skip if the contributor doesn't exist in our db

        @monitoring_configuration.monitoring_contributors.create!(
          github_repository_contributors_id: contributor.id
        )
      end
    end

    GithubHookCreatorJob.perform_later(@monitoring_configuration)

    success(@monitoring_configuration)
  end

end
