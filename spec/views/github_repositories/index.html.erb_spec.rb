require 'rails_helper'

RSpec.describe "github_repositories/index", type: :view do
  before(:each) do
    assign(:github_repositories, [
      GithubRepository.create!(),
      GithubRepository.create!()
    ])
  end

  it "renders a list of github_repositories" do
    render
  end
end
