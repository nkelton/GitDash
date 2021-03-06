module Inspectors
  ##
  # Github User Object that sent the event
  class GithubSender

    def initialize(sender)
      @sender = sender
    end

    attr_reader :sender

    def login
      sender['login']
    end

    def id
      sender['id']
    end

    def html_url
      sender['html_url']
    end

    def to_hash
      {
        github_id: id,
        gitub_login: login,
        html_url: html_url
      }
    end

  end
end
