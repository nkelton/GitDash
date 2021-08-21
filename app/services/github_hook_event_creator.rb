class GithubHookEventCreator < BaseService

  def initialize(github_hook_event_attrs)
    super()
    @github_hook_event_attrs = github_hook_event_attrs
  end

  attr_reader :github_hook_event_attrs

  def call
    unless github_github_hook_event.valid?
      add_error(github_github_hook_event.errors)
      return failure
    end

    github_github_hook_event.save!

    success(github_github_hook_event)
  end

  private

  def github_github_hook_event
    @github_github_hook_event ||= GithubHookEvent.new(
      github_hook_event_attrs
    )
  end

end
