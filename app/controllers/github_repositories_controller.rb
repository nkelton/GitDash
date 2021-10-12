class GithubRepositoriesController < ApplicationController
  load_and_authorize_resource

  # GET /github_repositories or /github_repositories.json
  def index
    # TODO: figure out pagination stuff
  end

  # GET /github_repositories/1 or /github_repositories/1.json
  def show
  end

  # GET /github_repositories/new
  def new
    @github_repository = GithubRepository.new
  end

  # GET /github_repositories/1/edit
  def edit
    @monitoring_configuration = @github_repository.monitoring_configuration || GithubRepositoryMonitoringConfiguration.new
  end

  # POST /github_repositories or /github_repositories.json
  def create
    @github_repository = GithubRepository.new(github_repository_params)

    respond_to do |format|
      if @github_repository.save
        format.html { redirect_to @github_repository, notice: "Github repository was successfully created." }
        format.json { render :show, status: :created, location: @github_repository }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @github_repository.errors, status: :unprocessable_entity }
      end
    end
  end

  def sync
    result = GithubRepositorySync.new(current_user.github_account).call

    if result.success?
      flash[:notice] = 'Github repository was successfully synced.'
    else
      flash[:warning] = 'Github repository was not successfully synced.'
    end

    redirect_to action: 'index'
  end

  define :patch, :update, ' github_repositories/{id}' do
    summary 'Create a monitoring configuration for a github repository.'
    description <<~MARKDOWN
      You can use this endpoint to create a GithubRepositoryMonitoringConfiguration record.
    MARKDOWN
    path_params { attribute :id, Types::Params::Integer }
    request_body do
      attribute :github_repository do
        attribute? :aasm_state, Types::Params::String
        attribute? :monitoring_configuration_attributes do
          attribute? :notification_types, Types::Params::Array
        end
        attribute? :contributors_to_monitor do
          attribute :ids, SoberSwag::Types::Array.of(Types::Params::String)
        end
      end
    end
  end
  def update
    update_params = parsed_body.to_h[:github_repository]
    github_repository = GithubRepository.find(parsed_path.id)

    # filter out empty strings
    update_params.tap do |params|
      params[:monitoring_configuration_attributes][:notification_types] = params[:monitoring_configuration_attributes][:notification_types].reject(&:empty?) if params.key?(:monitoring_configuration_attributes)
      params[:contributors_to_monitor][:ids] = params[:contributors_to_monitor][:ids].reject(&:empty?) if params.key?(:contributors_to_monitor)
    end

    result = GithubRepositoryUpdater.new(github_repository, update_params).call

    respond_to do |format|
      if result.success?
        redirect = result.data.first ? new_github_repository_github_repository_monitoring_configurations_path(result.data.second) : result.data.second
        format.html { redirect_to redirect, notice: "Github repository was successfully updated." }
        format.json { render :show, status: :ok, location: github_repository }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: result.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /github_repositories/1 or /github_repositories/1.json
  def destroy
    @github_repository.destroy
    respond_to do |format|
      format.html { redirect_to github_repositories_url, notice: "Github repository was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_github_repository
      @github_repository = GithubRepository.find(params[:id])
    end

    # TODO: remove when sober_swag is added to create endpoint
    def github_repository_params
      params.require(:github_repository).permit(:aasm_state)
    end
end
