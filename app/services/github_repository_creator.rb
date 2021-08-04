class GithubRepositoryCreator < BaseService

  def initialize(github_account)
    super()
    @github_account = github_account
  end

  def call
    repositories = Octokit::Client.new(access_token: @github_account.token).repositories
    ActiveRecord::Base.transaction do
      repositories.each do |repo|
        GithubRepository.create!(
          github_id: repo.id,
          name: repo.name,
          github_account: @github_account,
          metadata: repo.to_hash
        )
      end

      return success(@github_account.reload.github_repositories)
    end
  end

end