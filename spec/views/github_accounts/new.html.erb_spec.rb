require 'rails_helper'

RSpec.describe "github_accounts/new", type: :view do
  before(:each) do
    assign(:github_account, GithubAccount.new(
      :username => "MyString",
      :token => "MyString",
      :metadata => "",
      :user_id => 1
    ))
  end

  it "renders new github_account form" do
    render

    assert_select "form[action=?][method=?]", github_accounts_path, "post" do

      assert_select "input[name=?]", "github_account[username]"

      assert_select "input[name=?]", "github_account[token]"

      assert_select "input[name=?]", "github_account[metadata]"

      assert_select "input[name=?]", "github_account[user_id]"
    end
  end
end
