class CreateGithubRepositoryMonitoringContributors < ActiveRecord::Migration[6.1]
  def change
    create_table :github_repository_monitoring_contributors do |t|
      t.references(
        :github_repository_monitoring_configuration,
        foreign_key: { to_table: :github_repository_monitoring_configurations },
        index: { name: 'idx_gh_repo_monitoring_contributors_on_gh_monitoring_config_id' },
        type: :bigint,
        null: false
      )
      t.references(
        :github_repository_contributors,
        foreign_key: { to_table: :github_repository_contributors },
        index: { name: 'idx_gh_repo_monitoring_contributors_on_gh_contributors_id' },
        type: :bigint,
        null: false
      )
      t.timestamps
    end
  end
end
