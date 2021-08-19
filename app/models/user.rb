class User < ApplicationRecord
  has_secure_password

  has_one :github_account
  has_many :github_repositories, through: :github_account
  has_one :profile
end
