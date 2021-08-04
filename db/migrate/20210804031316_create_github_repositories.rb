class CreateGithubRepositories < ActiveRecord::Migration[6.1]
  def change
    create_table :github_repositories do |t|
      t.integer :github_id, unique: true, null: false
      t.string :name, null: false
      t.references :github_account, foreign_key: true, null: false
      t.jsonb :metadata, default: {}
      t.timestamps
    end
  end
end
