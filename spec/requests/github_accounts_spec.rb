require 'rails_helper'

RSpec.describe "GithubAccounts", type: :request do
  describe "GET /github_accounts" do
    it "works! (now write some real specs)" do
      get github_accounts_path
      expect(response).to have_http_status(200)
    end
  end
end
