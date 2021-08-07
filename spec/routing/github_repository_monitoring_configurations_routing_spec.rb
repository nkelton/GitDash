require "rails_helper"

RSpec.describe GithubRepositoryMonitoringConfigurationsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/github_repository_monitoring_configurations").to route_to("github_repository_monitoring_configurations#index")
    end

    it "routes to #new" do
      expect(get: "/github_repository_monitoring_configurations/new").to route_to("github_repository_monitoring_configurations#new")
    end

    it "routes to #show" do
      expect(get: "/github_repository_monitoring_configurations/1").to route_to("github_repository_monitoring_configurations#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/github_repository_monitoring_configurations/1/edit").to route_to("github_repository_monitoring_configurations#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/github_repository_monitoring_configurations").to route_to("github_repository_monitoring_configurations#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/github_repository_monitoring_configurations/1").to route_to("github_repository_monitoring_configurations#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/github_repository_monitoring_configurations/1").to route_to("github_repository_monitoring_configurations#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/github_repository_monitoring_configurations/1").to route_to("github_repository_monitoring_configurations#destroy", id: "1")
    end
  end
end
