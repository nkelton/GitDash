module Inspectors
  class GithubRepository

    def initialize(repository)
      @repository = repository
    end

    attr_reader :repository

    def id
      repository['id']
    end

    def html_url
      repository['html_url']
    end

  end
end
