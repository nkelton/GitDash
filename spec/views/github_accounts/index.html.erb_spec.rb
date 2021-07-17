require 'rails_helper'

RSpec.describe "github_accounts/index", type: :view do
  before(:each) do
    assign(:github_accounts, [
      GithubAccount.create!(
        :username => "Username",
        :token => "Token",
        :metadata => "",
        :user_id => 2
      ),
      GithubAccount.create!(
        :username => "Username",
        :token => "Token",
        :metadata => "",
        :user_id => 2
      )
    ])
  end

  it "renders a list of github_accounts" do
    render
    assert_select "tr>td", :text => "Username".to_s, :count => 2
    assert_select "tr>td", :text => "Token".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
