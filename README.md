# README

## Setup Database
1. PostgreSQL Database 12

## Download Redis for async processing
1. `brew update && brew install redis`
2. `brew services start redis`

## Server Setup
1. Install Gems - `bundle install`
2. Create Database - `bundle exec rake db:create`
3. Run Database Migrations - `bundle exec rake db:migrate`
4. Start server - `bundle exec rails s`
5. Start sidekiq - `bundle exec sidekiq`

## Working with Github Hooks locally
[Github Tutorial](https://docs.github.com/en/developers/webhooks-and-events/webhooks/creating-webhooks#exposing-localhost-to-the-internet)
1. Run Tunnel - `./ngrok http 3000`
2. Copy and paste the host name. It should look something like `17c2efbcd19a.ngrok.io`
3. Add `NGROK_HOST=#{your_host_name}` to your `.env` file