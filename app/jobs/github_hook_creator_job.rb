class GithubHookCreatorJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: false

  def perform(monitoring_configuration)
    GithubHookCreator.new(monitoring_configuration).call
  end
end