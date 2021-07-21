class CreateGithubAccount < ActiveRecord::Migration[6.1]

  def change
    create_table :github_accounts do |t|
      t.string :token, null: false
      t.jsonb :metadata, default: {}
      t.references :user, foreign_key: true, null: false, unique: true
      t.timestamps
    end
  end

end
