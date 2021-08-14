class GithubWebhookEventCreator < BaseService

  def initialize(webhook_event_attrs)
    super()
    @webhook_event_attrs = webhook_event_attrs
  end

  attr_reader :webhook_event_attrs

  def call
    unless github_webhook_event.valid?
      add_error(github_webhook_event.errors)
      return failure
    end

    github_webhook_event.save!

    success(github_webhook_event)
  end

  private

  def github_webhook_event
    @github_webhook_event ||= GithubWebhookEvent.new(
      webhook_event_attrs
    )
  end

end
