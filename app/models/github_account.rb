class GithubAccount < ApplicationRecord
  belongs_to :user
  has_many :github_repositories
  has_many :github_hooks, through: :github_repositories
  has_many :events, through: :github_hooks

  validates :user_id, uniqueness: true
  validates :token, presence: true

  METADATA_ATTRS = %w[
    bio url blog name email
    login company html_url
    location avatar_url
  ].freeze

  METADATA_ATTRS.each do |attribute|
    define_method attribute do
      metadata[attribute]
    end
  end

  def github_id
    metadata['id']
  end

end
