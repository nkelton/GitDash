class GithubAccount < ApplicationRecord

  belongs_to :user
  has_many :github_repositories

  validates :user_id, uniqueness: true
  validates :token, presence: true

end
