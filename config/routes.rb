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
  post 'github_repositories/sync'
  patch '/subscription' => 'subscriptions#update'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  root to: 'home#index'
end
