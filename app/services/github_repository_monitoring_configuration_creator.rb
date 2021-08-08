class GithubRepositoryMonitoringConfigurationCreator < BaseService

  def initialize(monitoring_configuration_params)
    super()
    @monitoring_configuration = GithubRepositoryMonitoringConfiguration.new(
      monitoring_configuration_params
    )
  end

  def call
    unless @monitoring_configuration.valid?
      add_error(@monitoring_configuration.errors)
      return failure
    end

    @monitoring_configuration.save!

    GithubHookCreatorJob.perform_later(@monitoring_configuration)

    success(@monitoring_configuration)
  end

end
