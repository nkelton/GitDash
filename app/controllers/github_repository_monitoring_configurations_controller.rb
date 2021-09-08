class GithubRepositoryMonitoringConfigurationsController < ApplicationController
  load_and_authorize_resource

  # GET /github_repository_monitoring_configurations or /github_repository_monitoring_configurations.json
  def index
    @github_repository_monitoring_configurations = GithubRepositoryMonitoringConfiguration.all
  end

  # GET /github_repository_monitoring_configurations/1 or /github_repository_monitoring_configurations/1.json
  def show
  end

  # GET /github_repository_monitoring_configurations/new
  def new
    @github_repository_monitoring_configuration = GithubRepositoryMonitoringConfiguration.new
    @github_repository = GithubRepository.find(params[:github_repository_id])
  end

  # GET /github_repository_monitoring_configurations/1/edit
  def edit
    @github_repository = GithubRepository.find(params[:github_repository_id])
  end

  define :post, :create, ' github_repositories/{id}/github_repository_monitoring_configurations' do
    summary 'Create a monitoring configuration for a github repository.'
    description <<~MARKDOWN
      You can use this endpoint to create a GithubRepositoryMonitoringConfiguration record.
    MARKDOWN
    path_params { attribute :github_repository_id, Types::Params::Integer }
    request_body do
      attribute :github_repository_monitoring_configuration do
        attribute :github_repository_id, Types::Params::Integer
        attribute :notification_types, Types::Params::Array
        attribute :contributors_to_monitor do
          attribute :ids, SoberSwag::Types::Array.of(Types::Params::String)
        end
      end
    end
  end
  def create
    create_params = parsed_body.to_h[:github_repository_monitoring_configuration]

    # filter out empty strings
    create_params.tap do |params|
      params[:notification_types] = params[:notification_types].reject(&:empty?)
      params[:contributors_to_monitor][:ids] = params[:contributors_to_monitor][:ids].reject(&:empty?)
    end

    result = GithubRepositoryMonitoringConfigurationCreator.new(create_params).call

    respond_to do |format|
      if result.success?
        redirect = github_repository_github_repository_monitoring_configurations_path(
          result.data.github_repository,
          id: result.data
        )

        format.html { redirect_to redirect, notice: "Github repository monitoring configuration was successfully created." }
        format.json { render :show, status: :created, location: result }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: result.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /github_repository_monitoring_configurations/1 or /github_repository_monitoring_configurations/1.json
  def update
    respond_to do |format|
      if @github_repository_monitoring_configuration.update(github_repository_monitoring_configuration_params)
        format.html { redirect_to @github_repository_monitoring_configuration, notice: "Github repository monitoring configuration was successfully updated." }
        format.json { render :show, status: :ok, location: @github_repository_monitoring_configuration }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @github_repository_monitoring_configuration.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /github_repository_monitoring_configurations/1 or /github_repository_monitoring_configurations/1.json
  def destroy
    @github_repository_monitoring_configuration.destroy
    respond_to do |format|
      format.html { redirect_to github_repository_monitoring_configurations_url, notice: "Github repository monitoring configuration was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_github_repository_monitoring_configuration
      @github_repository_monitoring_configuration = GithubRepositoryMonitoringConfiguration.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def github_repository_monitoring_configuration_params
      params.require(:github_repository_monitoring_configuration).permit(:github_repository_id, notification_types: [])
    end
end
