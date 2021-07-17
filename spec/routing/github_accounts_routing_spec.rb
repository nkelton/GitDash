require "rails_helper"

RSpec.describe GithubAccountsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/github_accounts").to route_to("github_accounts#index")
    end

    it "routes to #new" do
      expect(:get => "/github_accounts/new").to route_to("github_accounts#new")
    end

    it "routes to #show" do
      expect(:get => "/github_accounts/1").to route_to("github_accounts#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/github_accounts/1/edit").to route_to("github_accounts#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/github_accounts").to route_to("github_accounts#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/github_accounts/1").to route_to("github_accounts#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/github_accounts/1").to route_to("github_accounts#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/github_accounts/1").to route_to("github_accounts#destroy", :id => "1")
    end
  end
end
