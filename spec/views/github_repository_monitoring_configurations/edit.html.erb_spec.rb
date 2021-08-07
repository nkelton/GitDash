require 'rails_helper'

RSpec.describe "github_repository_monitoring_configurations/edit", type: :view do
  before(:each) do
    @github_repository_monitoring_configuration = assign(:github_repository_monitoring_configuration, GithubRepositoryMonitoringConfiguration.create!())
  end

  it "renders the edit github_repository_monitoring_configuration form" do
    render

    assert_select "form[action=?][method=?]", github_repository_monitoring_configuration_path(@github_repository_monitoring_configuration), "post" do
    end
  end
end
