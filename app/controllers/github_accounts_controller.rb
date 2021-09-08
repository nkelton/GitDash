class GithubAccountsController < ApplicationController
  load_and_authorize_resource

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

  define :post, :create, ' /github_accounts' do
    summary 'Create github account.'
    description <<~MARKDOWN
      You can use this endpoint to create a GithubAccount record.
      This resource must always be associated with a User.
    MARKDOWN
    request_body do
      attribute :github_account do
        attribute :user_id, Types::Params::Integer
        attribute :token, Types::Params::String
        attribute? :metadata, Types::Params::Hash
      end
    end
  end

  def create
    result = GithubAccountCreator.new(parsed_body.to_h[:github_account]).call
    @github_account = result.success? ? result.data : GithubAccount.new

    respond_to do |format|
      if result.success?
        format.html { redirect_to profile_path(@github_account.user.profile.id), notice: "Github account was successfully created." }
        format.json { render :show, status: :created, location: @github_account }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: result.errors, status: :unprocessable_entity }
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
      params.require(:github_account).permit(:token, :metadata, :user_id)
    end
end
