class GithubAccountCreator < BaseService

  def initialize(github_account_attrs)
    super()
    @github_account = GithubAccount.new(github_account_attrs)
  end

  def call
    unless @github_account.valid?
      add_error(@github_account.errors)
      return failure(@github_account)
    end

    create_token if create_token?

    unless @github_account.save
      add_error(@github_account.errors)
      return failure(@github_account)
    end

    success(@github_account.reload)
  end

  private

  def create_token?
    !@github_account.token?
  end

  def create_token
    'Creating_token...'
  end

end
