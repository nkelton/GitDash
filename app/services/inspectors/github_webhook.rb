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
      payload.key?(:hook)
    end

    def pull_request?
      payload.key?(:pull_request)
    end

    def repository?
      payload.key?(:repository)
    end

    def hook
      #TODO: implement inspector for this
    end

    def pull_request
      return @pull_request if defined?(@pull_request)

      @pull_request = Inspectors::GithubPullRequest.new(payload[:pull_request]) if pull_request?
    end

    def repository
      return @repository if defined?(@repository)

      @repository = Inspectors::GithubRepository.new(payload[:repository]) if repository?
    end

    def sender
      return @sender if defined?(@sender)

      @sender = Inspectors::GithubRepository.new(payload[:sender]) if sender?
    end

  end
end
