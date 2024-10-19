Rails.application.routes.draw do
  devise_for :users
  resources :notes, except: [ :show ]

  # Static Pages
  root to: "pages#home"
  get "about", to: "pages#about", as: :about

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
