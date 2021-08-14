class GithubPullRequestUpsertor < BaseService

  def initialize(pull_request_attrs)
    super()
    @pull_request_attrs = pull_request_attrs
  end

  attr_reader :pull_request_attrs

  def call
    if github_pull_request.present?
      update_pull_request!
    else
      create_pull_request!
    end

    return failure if errors?

    success(github_pull_request.reload)
  end

  private

  def github_pull_request
    @github_pull_request ||= GithubPullRequest.find_by(github_id: pull_request_attrs[:github_id])
  end

  def update_pull_request!
    github_pull_request.update!(pull_request_attrs)
  end

  def create_pull_request!
    unless pull_request.valid?
      add_errors(pull_request.errors)
      return
    end

    pull_request.save!
  end

  def pull_request
    @pull_request ||= GithubPullRequest.new(pull_request_attrs)
  end

end
