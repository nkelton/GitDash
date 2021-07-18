class AddPasswordToGithubAccount < ActiveRecord::Migration[6.1]

  def up
    add_column(
      :github_accounts,
      :password,
      :string,
      default: ''
    )
  end

  def down
    remove_column :github_accounts, :password
  end

end
