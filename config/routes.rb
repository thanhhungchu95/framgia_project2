Rails.application.routes.draw do
  root to: "statics#home"
  get "/about", to: "statics#about"
  get "/contact", to: "statics#contact"
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }
  as :user do
    get "/signup", to: "users/registrations#new"
    get "/edit", to: "users/registrations#edit"
    get "/signin", to: "users/sessions#new"
    post "/signup", to: "users/registrations#create"
    post "/signin", to: "users/sessions#create"
    delete "/signout", to: "users/sessions#destroy"
  end
  resources :users, only: [:index, :show]
end
