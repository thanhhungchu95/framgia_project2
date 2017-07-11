Rails.application.routes.draw do
  root to: "statics#home"
  get "/admin", to: "admins#user_manager", as: "admin_root"
  get "/admin/user_manager", to: "admins#user_manager", as: "admin_user_manager"
  get "/admin/post_manager", to: "admins#post_manager", as: "admin_post_manager"
  get "/about", to: "statics#about"
  get "/contact", to: "statics#contact"
  get "/create_post", to: "posts#new"
  get "/following", to: "statics#following"
  get "/popular", to: "statics#popular"
  post "/create_post", to: "posts#create"
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  as :user do
    get "/signup", to: "users/registrations#new"
    get "/edit", to: "users/registrations#edit"
    get "/signin", to: "users/sessions#new"
    post "/signup", to: "users/registrations#create"
    post "/signin", to: "users/sessions#create"
    delete "/signout", to: "users/sessions#destroy"
  end
  resources :users, only: [:index, :show, :destroy]
  resources :posts, except: :new do
    resources :comments, except: :new
  end
  resources :relationships, only: [:create, :destroy]
  resources :tags, only: [:index, :show]
  get "*path", to: redirect("404")
  post "*path", to: redirect("404")
end
