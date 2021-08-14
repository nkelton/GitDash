class CreateGithubPullRequest < ActiveRecord::Migration[6.1]
  def change
    create_table :github_pull_requests do |t|
      t.string :title, null: false, default: ''
      t.string :github_id, null: false, unique: true
      t.text :body, null: false, default: ''
      t.string :state, null: false
      t.jsonb :metadata, null: false, default: {}
      t.references :github_repository, null: false
      t.timestamps
    end
  end
end
