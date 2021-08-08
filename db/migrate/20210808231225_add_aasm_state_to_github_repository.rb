class AddAasmStateToGithubRepository < ActiveRecord::Migration[6.1]
  def up
    add_column :github_repositories, :aasm_state, :string
  end

  def down
    remove_column :github_repositories, :aasm_state
  end
end
