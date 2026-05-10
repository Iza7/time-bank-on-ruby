Rails.application.routes.draw do
  # Web — auth
  root "sessions#new"

  get  "/register", to: "users#new"
  post "/users",    to: "users#create"

  get    "/login",  to: "sessions#new"
  post   "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  # Web — profile
  get   "/profile",      to: "pages#profile"
  get   "/profile/edit", to: "pages#edit"
  patch "/profile",      to: "pages#update"

  # Web — services
  resources :services

  # Web — service requests
  resources :service_requests, only: %i[index show create] do
    member do
      patch :accept
      patch :reject
      patch :cancel
      patch :complete
    end
  end

  # Web — reviews
  resources :reviews, only: [:create]

  # Web — transaction history
  resources :transactions, only: [:index]

  # Buy credits
  get  '/buy-credits', to: 'payments#new'
  post '/buy-credits', to: 'payments#create'

  # Webhooks
  namespace :webhooks do
    post 'stripe', to: 'stripe#create'
  end

  # Web — admin
  namespace :admin do
    resources :users, only: %i[index show] do
      member do
        patch :toggle_active
      end
    end

    resources :services, only: [:index, :destroy] do
      member do
        patch :toggle_visible
      end
    end

    resources :transactions, only: [:index]
  end

  # API v1
  namespace :api do
    namespace :v1 do
      post "auth/register", to: "auth#register"
      post "auth/login",    to: "auth#login"

      resource  :profile,          only: %i[show update], controller: "users"
      resources :services
      resources :service_requests, only: %i[index show create] do
        member do
          patch :accept
          patch :reject
          patch :cancel
          patch :complete
        end
      end
      resources :transactions, only: [:index]
      resources :payments, only: [:create]
      resources :reviews, only: [:create]
    end
  end
end