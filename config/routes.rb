Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations'
  }

  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  authenticated :user do
    root to: "dashboard#index", as: :user_root
  end

  root to: "home#index"
  get '/dashboard/index' => 'dashboard#index'

  get '/form/index' => 'form#index'
  get '/form/mobilization' => 'form#mobilization'
  get '/form/training' => 'form#training'
  get '/form/arrestable' => 'form#arrestable'
  get '/form/street' => 'form#street'




end
