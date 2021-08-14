class CreateGithubWebhookEvent < ActiveRecord::Migration[6.1]
  def change
    create_table :github_webhook_events do |t|
      t.string :type, null: false, default: ''
      t.string :action, null: false, default: ''
      t.jsonb :sender, null: false, default: {}
      t.jsonb :metadata, null: false, default: {}
      t.references :github_hook, null: false
      t.timestamps
    end
  end
end
