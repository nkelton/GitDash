class CreateRpushAppForWebBrowsers < ActiveRecord::Migration[6.1]

  NAME = 'git-dash-web'.freeze

  def up
    Rpush::Webpush::App.create!(
      name: NAME,
      certificate: {
        subject: ENV['RPUSH_SUBJECT'],
        public_key: ENV['RPUSH_PUBLIC_KEY'],
        private_key: ENV['RPUSH_PRIVATE_KEY']
      }.to_json
    )
  end

  def down
    Rpush::App.find_by_name(NAME).delete
  end

end
