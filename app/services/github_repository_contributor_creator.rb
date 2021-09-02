class GithubRepositoryContributorCreator < BaseService

  def initialize(github_repository)
    super()
    @github_repository = github_repository
  end

  attr_reader :github_repository

  def call
    contributors = retrieve_contributors!

    ActiveRecord::Base.transaction do
      contributors.each do |contributor|
        github_repository.contributors.create!(
          login: contributor.login,
          github_id: contributor.id,
          metadata: metadata_for(contributor)
        )
      end
    end

    success(github_repository.reload.contributors)
  end

  private

  def retrieve_contributors!
    Octokit::Client.new(access_token: token).contribs(github_repository.github_id)
  end

  def metadata_for(contributor)
    {
      html_url: contributor.html_url,
      contributions: contributor.contributions
    }
  end

  def token
    github_repository.github_account.token
  end

end
