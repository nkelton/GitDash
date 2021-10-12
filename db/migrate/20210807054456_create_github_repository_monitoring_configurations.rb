class CreateGithubRepositoryMonitoringConfigurations < ActiveRecord::Migration[6.1]
  def change
    create_table :github_repository_monitoring_configurations do |t|
      t.references :github_repository, null: false, foreign_key: true, index: { name: 'idx_gh_repository_monitoring_config_on_gh_repository_id', unique: true, }
      t.text :notification_types, array: true, default: []
      t.timestamps
    end
  end

end
