Rails.application.routes.draw do
  root to: "statics#home"
  get "/about", to: "statics#about"
  get "/contact", to: "statics#contact"
  devise_for :users
end
