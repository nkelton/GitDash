module Inspectors
  class GithubWebhook

    def initialize(webhook)
      @webhook = webhook
    end

    attr_reader :webhook

    def action
      webhook['action']
    end

    def hook?
      webhook.key?(:hook)
    end

    def pull_request?
      webhook.key?(:pull_request)
    end

    def repository?
      webhook.key?(:repository)
    end

    def sender?
      webhook.key?(:sender)
    end

    def hook
      #TODO: implement inspector for this
    end

    def pull_request
      return @pull_request if defined?(@pull_request)

      @pull_request = Inspectors::GithubPullRequest.new(webhook[:pull_request]) if pull_request?
    end

    def repository
      return @repository if defined?(@repository)

      @repository = Inspectors::GithubRepository.new(webhook[:repository]) if repository?
    end

    def sender
      return @sender if defined?(@sender)

      @sender = Inspectors::GithubSender.new(webhook[:sender]) if sender?
    end

  end
end
