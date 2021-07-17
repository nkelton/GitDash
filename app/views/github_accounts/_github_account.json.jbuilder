json.extract! github_account, :id, :username, :token, :metadata, :user_id, :created_at, :updated_at
json.url github_account_url(github_account, format: :json)
