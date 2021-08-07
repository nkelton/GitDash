require 'rails_helper'

RSpec.describe "github_repository_monitoring_configurations/new", type: :view do
  before(:each) do
    assign(:github_repository_monitoring_configuration, GithubRepositoryMonitoringConfiguration.new())
  end

  it "renders new github_repository_monitoring_configuration form" do
    render

    assert_select "form[action=?][method=?]", github_repository_monitoring_configurations_path, "post" do
    end
  end
end
