require 'rails_helper'

RSpec.describe "github_repositories/new", type: :view do
  before(:each) do
    assign(:github_repository, GithubRepository.new())
  end

  it "renders new github_repository form" do
    render

    assert_select "form[action=?][method=?]", github_repositories_path, "post" do
    end
  end
end
