module Inspectors
  class GithubPayload

    class GithubPayloadError < StandardError; end

    def initialize(payload)
      raise GithubPayloadError, 'Cannot inspect. Not a valid github payload!' unless payload?

      @payload = payload
    end

    attr_reader :payload

    def payload?
      payload[:action] == 'payload'
    end

    def webhook
      return @webhook if defined?(@webhook)

      @webhook = Inspectors::GithubPullRequest.new(payload[:webhook]) if webhook?
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
      #TODO: implement
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



