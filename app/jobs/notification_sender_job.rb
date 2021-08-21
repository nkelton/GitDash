class NotificationSenderJob < ApplicationJob
  queue_as :default

  def perform(data)
    NotificationSender.new(
      message: data[:message],
      user: data[:user]
    ).call
  end
end
