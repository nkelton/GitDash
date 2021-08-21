class GithubWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def payload
    GithubHookEventProcessor.new(webhook_params).call
  end

  def webhook_params
    params.require(:github_webhook)
  end

end
