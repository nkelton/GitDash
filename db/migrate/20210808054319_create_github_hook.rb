class CreateGithubHook < ActiveRecord::Migration[6.1]
  def change
    create_table :github_hooks do |t|
      t.references :github_repository_monitoring_configuration, null: false, index: { name: 'index_gh_hooks_on_gh_monitoring_configuration_id' }
      t.integer :github_id, null: false
      t.jsonb :metadata, default: {}
      t.timestamps
    end
  end
end
