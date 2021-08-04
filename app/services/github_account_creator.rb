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

    unless @github_account.save
      add_error(@github_account.errors)
      return failure
    end

    GithubRepositoryCreatorJob.perform_later(@github_account)

    success(@github_account)
  end

  private

  def valid_token?
    client = Octokit::Client.new(access_token: @github_account.token)
    begin
      client.login.present?
    rescue StandardError
      false
    end
  end

end
