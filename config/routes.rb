Rails.application.routes.draw do
  devise_for :users
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  
  resources :search_analytics, only: [:index] do
    get :results, on: :collection
  end
  
  resources :articles
  get "up" => "rails/health#show", as: :rails_health_check

  root "articles#index"
end
