class User < ApplicationRecord
  has_secure_password

  has_one :github_account
  has_many :github_repositories, through: :github_account
  has_one :profile

  delegate :can?, :cannot?, to: :ability

  def ability
    @ability ||= Ability.new(self)
  end

end
