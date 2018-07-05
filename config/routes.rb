Rails.application.routes.draw do
  get 'letters/index'
  resources :letters
  root 'letters#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
