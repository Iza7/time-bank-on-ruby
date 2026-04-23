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

  # Web — transaction history
  resources :transactions, only: [:index]

  # Web — admin
  namespace :admin do
    resources :users, only: %i[index show]
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
    end
  end
end
