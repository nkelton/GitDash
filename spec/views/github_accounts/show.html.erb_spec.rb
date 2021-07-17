require 'rails_helper'

RSpec.describe "github_accounts/show", type: :view do
  before(:each) do
    @github_account = assign(:github_account, GithubAccount.create!(
      :username => "Username",
      :token => "Token",
      :metadata => "",
      :user_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Username/)
    expect(rendered).to match(/Token/)
    expect(rendered).to match(//)
    expect(rendered).to match(/2/)
  end
end
