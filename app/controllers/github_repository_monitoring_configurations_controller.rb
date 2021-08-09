class GithubRepositoryMonitoringConfigurationsController < ApplicationController
  before_action :set_github_repository_monitoring_configuration, only: %i[ show edit update destroy ]

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
  end

  # POST /github_repository_monitoring_configurations or /github_repository_monitoring_configurations.json
  def create
    result = GithubRepositoryMonitoringConfigurationCreator.new(github_repository_monitoring_configuration_params).call

    respond_to do |format|
      if result.success?
        format.html { redirect_to result.data, notice: "Github repository monitoring configuration was successfully created." }
        format.json { render :show, status: :created, location: @github_repository_monitoring_configuration }
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
      params.fetch(:github_repository_monitoring_configuration, {})
    end
end
