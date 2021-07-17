require 'rails_helper'

RSpec.describe "github_accounts/edit", type: :view do
  before(:each) do
    @github_account = assign(:github_account, GithubAccount.create!(
      :username => "MyString",
      :token => "MyString",
      :metadata => "",
      :user_id => 1
    ))
  end

  it "renders the edit github_account form" do
    render

    assert_select "form[action=?][method=?]", github_account_path(@github_account), "post" do

      assert_select "input[name=?]", "github_account[username]"

      assert_select "input[name=?]", "github_account[token]"

      assert_select "input[name=?]", "github_account[metadata]"

      assert_select "input[name=?]", "github_account[user_id]"
    end
  end
end
