class GithubWebhookEvent < ApplicationRecord
  self.inheritance_column = :_type_disabled

  belongs_to :github_hook
end
