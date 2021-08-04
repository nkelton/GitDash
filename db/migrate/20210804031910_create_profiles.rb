class CreateProfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :profiles do |t|
      t.references :user, unique: true
      t.jsonb :metadata, default: {}
      t.timestamps
    end
  end
end
