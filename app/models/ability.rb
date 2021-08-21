class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    can :manage, Profile, user: user
    can :manage, GithubAccount, user: user

    github_account = user&.github_account
    return unless github_account.present?

    can :manage, GithubRepositoryMonitoringConfiguration, github_account: github_account
    can :manage, GithubRepository, github_account: github_account
  end
end
