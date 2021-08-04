require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  resources :profiles
  resources :github_repositories
  resources :github_accounts
  resources :users
  get 'home/index'
  root to: 'home#index'
end
