Rails.application.routes.draw do
  require "sidekiq/web"

  # Devise Authentication
  devise_for :users, controllers: { registrations: "users/registrations", omniauth_callbacks: "users/omniauth_callbacks" }
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
  resources :notes, except: [ :show, :edit, :new ] do
    member do
      patch :archive, :toggle_completion
    end
  end

  # Leaderboard
  get "leaderboard", to: "notes#leaderboard"

  # Stripe (Subscriptions and Webhooks)
  scope controller: :static do
    get :pricing
  end

  namespace :purchase do
    resources :checkouts, only: [ :create ] do
      collection do
        get "success", to: "checkouts#success"
      end
    end
  end

  resources :webhooks, only: :create

  resources :subscriptions

  # Static Pages
  get "about", to: "pages#about", as: :about

  # Blog
  get "/blog", to: "blog#index"
  get "/blog/:slug", to: "blog#show", as: "blog_post"

  # API namespace for isolated routes
  namespace :api do
    get "hello", to: proc { [ 200, { "Content-Type" => "application/json" }, [ '{"message":"Hello, World!"}' ] ] }
  end

  # Health check route for load balancers and uptime monitors
  get "up", to: "rails/health#show", as: :health_check

  # PWA related routes
  get "service-worker", to: "rails/pwa#service_worker", as: :service_worker
  get "manifest", to: "rails/pwa#manifest", as: :pwa_manifest
end
