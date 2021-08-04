require 'rails_helper'

RSpec.describe "github_repositories/edit", type: :view do
  before(:each) do
    @github_repository = assign(:github_repository, GithubRepository.create!())
  end

  it "renders the edit github_repository form" do
    render

    assert_select "form[action=?][method=?]", github_repository_path(@github_repository), "post" do
    end
  end
end
