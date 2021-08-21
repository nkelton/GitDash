class CreateGithubHook < ActiveRecord::Migration[6.1]
  def change
    create_table :github_hooks do |t|
      t.references :github_repository, null: false
      t.integer :github_id, null: false
      t.jsonb :metadata, default: {}
      t.timestamps
    end
  end
end
