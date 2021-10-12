class GithubRepositoryCreator < BaseService

  def initialize(github_account)
    super()
    @github_account = github_account
  end

  def call
    repositories = retrieve_repositories!
    ActiveRecord::Base.transaction do
      repositories.each do |repo|
        github_repo = GithubRepository.create!(
          github_id: repo.id,
          name: repo.name,
          github_account: @github_account,
          metadata: repo.to_hash
        )

        GithubRepositoryContributorCreatorJob.perform_later(github_repo)
      end

      return success(@github_account.reload.github_repositories)
    end
  end

  private

  def retrieve_repositories!
    Octokit::Client.new(access_token: @github_account.token).repositories
  end

end