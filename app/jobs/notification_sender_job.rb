class NotificationSenderJob < ApplicationJob
  queue_as :default

  def perform(message, user)
    NotificationSender.new(
      message: message,
      user: user
    ).call
  end
end
