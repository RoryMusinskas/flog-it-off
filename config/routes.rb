Rails.application.routes.draw do
  get 'home/page'
  devise_for :users
  resources :collections
  root to: 'home#page'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
