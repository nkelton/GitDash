module Inspectors
  class GithubPullRequest

    def initialize(pull_request)
      @pull_request = pull_request
    end

    attr_reader :pull_request

    def html_url
      pull_request['html_url']
    end

    def title
      pull_request['title']
    end

    def body
      pull_request['body']
    end

    def github_id
      pull_request['id']
    end

    def state
      pull_request['state']
    end

    def merged_at
      pull_request['merged_at']
    end

    def closed_at
      pull_request['closed_at']
    end

    def to_hash
      {
        html_url: html_url,
        head: {
          ref: head['ref'],
          sha: head['sha'],
          user_id: head.dig(:user, :id)
        },
        merged_at: merged_at,
        closed_at: closed_at
      }
    end

    private

    def head
      pull_request['head']
    end

  end
end
