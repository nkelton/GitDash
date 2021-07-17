class GithubAccountsController < ApplicationController
  before_action :set_github_account, only: %i[ show edit update destroy ]

  # GET /github_accounts or /github_accounts.json
  def index
    @github_accounts = GithubAccount.all
  end

  # GET /github_accounts/1 or /github_accounts/1.json
  def show
  end

  # GET /github_accounts/new
  def new
    @github_account = GithubAccount.new
  end

  # GET /github_accounts/1/edit
  def edit
  end

  # POST /github_accounts or /github_accounts.json
  def create
    @github_account = GithubAccount.new(github_account_params)

    respond_to do |format|
      if @github_account.save
        format.html { redirect_to @github_account, notice: "Github account was successfully created." }
        format.json { render :show, status: :created, location: @github_account }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @github_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /github_accounts/1 or /github_accounts/1.json
  def update
    respond_to do |format|
      if @github_account.update(github_account_params)
        format.html { redirect_to @github_account, notice: "Github account was successfully updated." }
        format.json { render :show, status: :ok, location: @github_account }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @github_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /github_accounts/1 or /github_accounts/1.json
  def destroy
    @github_account.destroy
    respond_to do |format|
      format.html { redirect_to github_accounts_url, notice: "Github account was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_github_account
      @github_account = GithubAccount.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def github_account_params
      params.require(:github_account).permit(:username, :token, :metadata, :user_id)
    end
end
