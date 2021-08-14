class GithubPullRequestProcessor < BaseService

  class GithubPullRequestProcessorError < StandardError; end

  def initialize(webhook_inspector)
    super()
    @webhook_inspector = webhook_inspector
  end

  attr_reader :webhook_inspector

  def call
    ActiveRecord::Base.transaction do
      pull_request_result = GithubPullRequestUpsertor.new(pull_request_attrs).call
      raise_error!(pull_request_result) if pull_request_result.failure?

      webhook_event_result = GithubWebhookEventCreator.new(webhook_event_attrs).call
      raise_error!(webhook_event_result) if webhook_event_result.failure?
    end
    # TODO: actually send the notification to the user
    success
  end

  private

  def pull_request_attrs
    {
      title: pull_request_inspector.title,
      github_id: pull_request_inspector.github_id,
      body: pull_request_inspector.body || '',
      state: pull_request_inspector.state,
      metadata: pull_request_metadata,
      github_repository_id: github_repository&.id
    }
  end

  def webhook_event_attrs
    {
      metadata: event_metadata,
      action: webhook_inspector.action,
      github_hook_id: github_hook_id,
      type: 'pull_request'
    }
  end

  def pull_request_metadata
    pull_request_inspector.to_hash
  end

  def event_metadata
    {
      sender: sender_inspector.to_hash
    }
  end

  def github_hook_id
    github_repository.github_hook.id
  end

  def github_repository
    @github_repository ||= GithubRepository.find_by(github_id: repository_inspector.id)
  end

  def github_webhook
    github_repository.github_webhook
  end

  def pull_request_inspector
    webhook_inspector.pull_request
  end

  def repository_inspector
    webhook_inspector.repository
  end

  def sender_inspector
    webhook_inspector.sender
  end

  def raise_error!(result)
    raise GithubPullRequestProcessorError, result.errors
  end

end
