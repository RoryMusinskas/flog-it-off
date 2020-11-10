Rails.application.routes.draw do
  root to: 'home#page'
  get 'home/page'
  get 'payments/success', to: 'payments#success'
  post '/payments/webhook', to: 'payments#webhook'
  devise_for :users
  resources :collections
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # each time a post request is made, run the increment method
  resources :collections do
    post :increment
  end

end
