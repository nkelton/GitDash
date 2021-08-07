class Profile < ApplicationRecord
  belongs_to :user
  has_many :github_repositories, through: :user
  has_one :github_account, through: :user

  def name
    user.name
  end

end
