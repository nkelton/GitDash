class AddUniqueUserIdIndexToGitHubAccount < ActiveRecord::Migration[6.1]
  
  def up
    add_index :github_accounts, :user_id, unique: true
  end

  def down
    remove_index :github_accounts, :user_id
  end

end
