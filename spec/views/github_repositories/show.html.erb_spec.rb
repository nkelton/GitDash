require 'rails_helper'

RSpec.describe "github_repositories/show", type: :view do
  before(:each) do
    @github_repository = assign(:github_repository, GithubRepository.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
