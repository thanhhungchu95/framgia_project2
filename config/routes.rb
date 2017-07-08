Rails.application.routes.draw do
  root to: "statics#home"
  get "/about", to: "statics#about"
  get "/contact", to: "statics#contact"
  get "/create_post", to: "posts#new"
  get "/following", to: "statics#following"
  get "/popular", to: "statics#popular"
  post "/create_post", to: "posts#create"
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
  resources :posts, except: :new do
    resources :comments, except: :new
  end
  resources :relationships, only: [:create, :destroy]
  get "*path", to: redirect("404")
  post "*path", to: redirect("404")
end
