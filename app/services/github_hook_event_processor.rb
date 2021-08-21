class GithubHookEventProcessor < BaseService

  def initialize(github_hook_event)
    super()
    @webhook_inspector = Inspectors::GithubWebhook.new(github_hook_event)
  end

  attr_reader :webhook_inspector

  def call
    return process_hook if webhook_inspector.hook?
    return process_pull_request if webhook_inspector.pull_request?

    error_and_fail
  end

  private

  def process_hook
    # TODO: process hooks - attempt to upsert.
  end

  def process_pull_request
    GithubPullRequestEventProcessor.new(webhook_inspector).call
  end

  def error_and_fail
    add_error('Payload type not supported')
    failure
  end

end
