class UsersController < ApplicationController
  include SoberSwag::Controller

  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  define :post, :create, ' /users' do
    summary 'Create user.'
    description <<~MARKDOWN
      You can use this endpoint to create a User record.
    MARKDOWN
    request_body do
      attribute :user do
        attribute :name, Types::Params::String
        attribute :email, Types::Params::String
        attribute :password, Types::Params::String
        attribute :password_confirmation, Types::Params::String
      end
    end
  end

  def create
    result = UserCreator.new(parsed_body.to_h[:user]).call
    @user = result.data
    session[:user_id] = @user.id.to_s

    respond_to do |format|
      if result.success?
        format.html { redirect_to new_github_account_path(user_id: @user.id), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
