require 'rails_helper'

RSpec.describe "github_repository_monitoring_configurations/show", type: :view do
  before(:each) do
    @github_repository_monitoring_configuration = assign(:github_repository_monitoring_configuration, GithubRepositoryMonitoringConfiguration.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
