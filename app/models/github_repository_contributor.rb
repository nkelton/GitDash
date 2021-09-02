class GithubRepositoryContributor < ApplicationRecord
  belongs_to :github_repository

  def html_url
    metadata['html_url']
  end

  def contributions
    metadata['contributions']
  end

end
