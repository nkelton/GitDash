class GithubHookEvent < ApplicationRecord
  self.inheritance_column = :_type_disabled

  belongs_to :github_hook

  def sender
    metadata['sender']
  end

  def object
    metadata['object']
  end

  def sender_login
    sender['gitub_login']
  end

  def sender_html_url
    sender['html_url']
  end

  def object_html_url
    object['html_url']
  end

end
