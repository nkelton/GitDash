class GithubRepositoryContributorCreatorJob < ApplicationJob
  queue_as :default

  def perform(github_repository)
    GithubRepositoryContributorCreator.new(github_repository).call
  end
end
