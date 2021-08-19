class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    can :manage, Profile, user: user
    can :manage, GithubAccount, user: user
    can :manage, GithubRepositoryMonitoringConfiguration, user: user
    can :manage, GithubRepository, user: user
  end
end
