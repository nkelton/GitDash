class AddWebPushSubscriptionToProfiles < ActiveRecord::Migration[6.1]
  def up
    add_column :profiles, :web_push_subscription, :jsonb, default: {}, null: false
  end

  def down
    remove_column :profiles, :web_push_subscription
  end
end
