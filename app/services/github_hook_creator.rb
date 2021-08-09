class GithubHookCreator < BaseService

  NAME = 'web'.freeze
  URL = "http://#{ENV['NGROK_HOST']}/github_webhooks/payload".freeze

  def initialize(monitoring_configuration)
    super()
    @monitoring_configuration = monitoring_configuration
  end

  def call
    github_hook = create_github_hook!

    success(
      GithubHook.create!(
        github_id: github_hook.id,
        github_repository_monitoring_configuration_id: @monitoring_configuration.id,
        metadata: github_hook.to_hash
      )
    )
  end

  private

  def create_github_hook!
    # http://octokit.github.io/octokit.rb/Octokit/Client/Hooks.html#create_hook-instance_method
    client.create_hook(
      repository.github_id,
      NAME,
      config,
      options
    )
  end

  def client
    Octokit::Client.new(
      access_token: access_token
    )
  end

  def config
    {
      url: URL,
      content_type: 'json'
    }
  end

  def options
    {
      events: @monitoring_configuration.notification_types,
      active: true
    }
  end

  def access_token
    @monitoring_configuration.github_account.token
  end

  def repository
    @monitoring_configuration.github_repository
  end

end