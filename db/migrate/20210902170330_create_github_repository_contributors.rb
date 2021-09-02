class CreateGithubRepositoryContributors < ActiveRecord::Migration[6.1]
  def change
    create_table :github_repository_contributors do |t|
      t.string :login, null: false
      t.integer :github_id, null: false
      t.jsonb :metadata, null: false, default: {}
      t.references :github_repository, null: false
      t.timestamps
    end
  end
end
