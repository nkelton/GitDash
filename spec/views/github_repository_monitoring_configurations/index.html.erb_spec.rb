require 'rails_helper'

RSpec.describe "github_repository_monitoring_configurations/index", type: :view do
  before(:each) do
    assign(:github_repository_monitoring_configurations, [
      GithubRepositoryMonitoringConfiguration.create!(),
      GithubRepositoryMonitoringConfiguration.create!()
    ])
  end

  it "renders a list of github_repository_monitoring_configurations" do
    render
  end
end
