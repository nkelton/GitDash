class SessionsController < ApplicationController

  def new
  end

  define :post, :create, ' /sessions' do
    summary 'Creates a user session.'
    description <<~MARKDOWN
      You can use this endpoint to create a session for a User.
    MARKDOWN
    request_body do
      attribute :login do
        attribute :email, Types::Params::String
        attribute :password, Types::Params::String
      end
    end
  end

  def create
    login = parsed_body.to_h[:login]
    user = User.find_by(email: login[:email])

    if user && user&.authenticate(login[:password])
      session[:user_id] = user.id.to_s
      redirect_to profile_path(user.profile.id), notice: 'Successfully logged in!'
    else
      flash.now.alert = 'Incorrect email or password, try again.'
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to login_path, notice: 'Logged out!'
  end
end