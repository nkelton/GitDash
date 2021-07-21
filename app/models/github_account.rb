class GithubAccount < ApplicationRecord

  belongs_to :user

  validates :user_id, uniqueness: true
  validates :token, presence: true

end
