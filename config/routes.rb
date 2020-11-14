Rails.application.routes.draw do
  get '/user/profile' => 'account#profile'
  root to: 'home#page'
  get 'home/page'
  get 'payments/success', to: 'payments#success'
  get 'stripe/connect', to: 'stripe#connect', as: :stripe_connect
  get 'stripe/dashboard/:user_id', to: 'stripe#dashboard', as: :stripe_dashboard
  post '/payments/webhook', to: 'payments#webhook'
  post '/payments/free_collection', to: 'payments#free_collection'
  devise_for :users
  resources :collections
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # each time a post request is made, run the increment method
  resources :collections do
    post :increment
  end
end
