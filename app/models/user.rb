class User < ApplicationRecord

  has_one :github_account
  has_one :profile

end
