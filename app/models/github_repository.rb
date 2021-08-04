class GithubRepository < ApplicationRecord
  belongs_to :github_account

  validates :github_id, uniqueness: true
  validates :name, presence: true
end
