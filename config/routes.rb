Rails.application.routes.draw do
  require "sidekiq/web"

  # Devise Authentication
  devise_for :users
  devise_scope :user do
    authenticated :user do
      root to: "notes#index", as: :authenticated_root
    end
    unauthenticated do
      root to: "pages#home"
    end
  end

  # Sidekiq Admin Interface
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => "/sidekiq"
  end

  # Notes (Task Management)
  resources :notes, except: [ :show ] do
    member do
      patch :archive, :toggle_completion
    end
    collection do
      get :leaderboard
    end
  end

  # Static Pages
  get "about", to: "pages#about"
  get "pricing", to: "static#pricing"

  # Blog
  get "blog", to: "blog#index"
  get "blog/:slug", to: "blog#show", as: "blog_post"

  # Stripe (Subscriptions and Webhooks)
  namespace :purchase do
    resources :checkouts, only: [ :create ] do
      get "success", on: :collection
    end
  end
  resources :subscriptions, only: [ :index, :create, :destroy ]
  post "webhooks", to: "webhooks#create"

  # API Namespace
  namespace :api do
    get "hello", to: proc { [ 200, { "Content-Type" => "application/json" }, [ '{"message":"Hello, World!"' ] ] }
  end

  # Health Check
  get "up", to: "rails/health#show"

  # PWA Routes
  get "service-worker", to: "rails/pwa#service_worker"
  get "manifest", to: "rails/pwa#manifest"
end
