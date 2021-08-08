class GithubHookCreatorJob < ApplicationJob
  queue_as :default

  def perform(monitoring_configuration)
    GithubHookCreator.new(monitoring_configuration).call
  end
end