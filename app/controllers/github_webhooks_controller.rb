class GithubWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def payload
    # TOOD: process webhooks here
  end
end
