class GithubRepositoryCreatorJob < ApplicationJob
  queue_as :default

  def perform(github_account)
    GithubRepositoryCreator.new(github_account).call
  end
end
