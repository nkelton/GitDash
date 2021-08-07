class GithubAccountCreator < BaseService

  def initialize(github_account_attrs)
    super()
    @github_account = GithubAccount.new(github_account_attrs)
  end

  def call
    unless @github_account.valid?
      add_error(@github_account.errors)
      return failure
    end

    unless valid_token?
      add_error('Github token is invalid')
      return failure
    end

    @github_account.tap do |github_account|
      github_account.metadata = github_metadata
      github_account.save!
    end

    GithubRepositoryCreatorJob.perform_later(@github_account)

    success(@github_account)
  end

  private

  def github_metadata
    client.user.to_hash
  end

  def client
    @client ||= Octokit::Client.new(access_token: @github_account.token)
  end

  def valid_token?
    client.login.present?
  rescue StandardError
    false
  end

end
