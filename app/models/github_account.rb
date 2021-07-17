class GithubAccount < ApplicationRecord

  belongs_to :user

  validates :username, presence: true
  validates :user_id, uniqueness: true

end
