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

  end
end
