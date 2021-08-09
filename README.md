# README

# Setup Database
1. PostgreSQL Database 12

# Download Redis for async processing
1. `brew update && brew install redis`
2. `brew services start redis`

## Server Setup
1. Install Gems - `bundle install`
2. Create Database - `bundle exec rake db:create`
3. Run Database Migrations - `bundle exec rake db:migrate`
4. Start server - `bundle exec rails s`
5. Start sidekiq - `bundle exec sidekiq`
