class GithubRepositorySync < BaseService

  def initialize(github_account)
    super()
    @github_account = github_account
  end

  attr_reader :github_account

  def call
    github_repositories = retrieve_repositories!

    ActiveRecord::Base.transaction do
      github_repositories.each do |gh_repo|
        add_repo(gh_repo) unless gh_repo.id.in?(existing_repository_ids)
      end
    end

    success
  end

  private

  def existing_repository_ids
    @existing_repository_ids ||= github_account.github_repositories.pluck(:github_id)
  end

  def add_repo(gh_repo)
    GithubRepository.create!(
      github_id: gh_repo.id,
      name: gh_repo.name,
      github_account: github_account,
      metadata: gh_repo.to_hash
    )
  end

  def retrieve_repositories!
    Octokit::Client.new(access_token: github_account.token).repositories
  end

end
