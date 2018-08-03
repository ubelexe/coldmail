Rails.application.routes.draw do
  mount Coldmail::API => '/'
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  resources :letters do
    get 'email', on: :collection
    get 'statistic', on: :collection
    get 'graph', on: :collection
    member do
      get :running
      get :sleeping
      get :completed
    end
  end
  root 'letters#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
