class GithubRepositoriesController < ApplicationController
  before_action :set_github_repository, only: %i[ show edit update destroy ]

  # GET /github_repositories or /github_repositories.json
  def index
    @github_repositories = GithubRepository.all
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

  # PATCH/PUT /github_repositories/1 or /github_repositories/1.json
  def update
    respond_to do |format|
      if @github_repository.update(github_repository_params)
        format.html { redirect_to @github_repository, notice: "Github repository was successfully updated." }
        format.json { render :show, status: :ok, location: @github_repository }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @github_repository.errors, status: :unprocessable_entity }
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

    # Only allow a list of trusted parameters through.
    def github_repository_params
      params.fetch(:github_repository, {})
    end
end
