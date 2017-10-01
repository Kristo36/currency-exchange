Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'exchanges#new'

  get 'get_quotes', to: 'currency_quotes#get_quote'

  resources :currency_quotes
  resources :exchanges
end
