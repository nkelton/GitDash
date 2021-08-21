class NotificationSender < BaseService

  WEB_NAME = 'git-dash-web'.freeze

  def initialize(message:, user:)
    super()
    @message = message
    @user = user
  end

  attr_reader :message, :user

  def call
    success(
      Rpush::Webpush::Notification.create!(
        app: app,
        registration_ids: registration_ids,
        data: data
      )
    )
  end

  private

  def data
    {
      message: message.to_json
    }
  end

  # Add some validation around here, so we don't end up with user as nil or a profile with an empty web_push_subscription
  def registration_ids
    [user.profile.web_push_subscription.except('expirationTime').deep_symbolize_keys]
  end

  def app
    @app ||= Rpush::App.find_by_name(WEB_NAME)
  end

end
