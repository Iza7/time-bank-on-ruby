Rails.application.routes.draw do
  get "services/index"
  get "services/new"
  get "services/create"
  get "pages/profile"
  root "sessions#new"

  get "/register", to: "users#new"
  post "/users", to: "users#create"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "/profile", to: "pages#profile"

  resources :services
  
end


