require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  resources :profiles
  resources :github_repositories do
    resource :github_repository_monitoring_configurations
  end
  resources :github_accounts do
    get :swagger, on: :collection
  end
  resources :github_hook_events
  resources :users do
    get :swagger, on: :collection
  end
  # TODO: rails cant figure out custom login routes with swagger on like this... need to figure out
  # resources :sessions do
  #   get :swagger, on: :collection
  # end
  get 'home/index'
  post 'github_webhooks/payload'
  post 'github_repositories/sync'
  patch '/subscription' => 'subscriptions#update'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  root to: 'home#index'
end
