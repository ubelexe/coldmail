Rails.application.routes.draw do
  match 'bootstrap', to: 'letters#bootstrap', via: 'get'
  resources :letters do
    member do
      get :running
      get :sleeping
      get :completed
    end

  end
  root 'letters#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
