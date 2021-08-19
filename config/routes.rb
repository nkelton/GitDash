require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  resources :profiles
  resources :github_repositories do
    resource :github_repository_monitoring_configurations
  end
  resources :github_accounts
  resources :users
  get 'home/index'
  post 'github_webhooks/payload'
  patch '/subscription' => 'subscriptions#update'
  root to: 'home#index'
end
