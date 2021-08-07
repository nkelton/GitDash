class AddMonitoringNotificationsFlagToGithubRepositories < ActiveRecord::Migration[6.1]

  def up
    add_column(
      :github_repositories,
      :monitoring_notifications,
      :boolean,
      default: false,
      null: false,
      comment: <<~COMMENT
        Indicates whether notifications are being monitored for this repository
      COMMENT
    )
  end

  def down
    remove_column :github_repositories, :monitoring_notifications
  end
end
