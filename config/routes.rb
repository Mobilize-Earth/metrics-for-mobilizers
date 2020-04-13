Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations'
  }

  resources :users
  resources :chapters
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  authenticated :user do
    root to: "dashboard#index", as: :user_root
  end

  root to: "home#index"
  get '/dashboard/index' => 'dashboard#index'

  get '/forms/index' => 'forms#index'
  get '/forms/mobilization' => 'forms#mobilization'
  get '/forms/training' => 'forms#training'
  get '/forms/arrestable' => 'forms#arrestable'
  get '/forms/street' => 'forms#street'

  get 'admins/index' => 'admins#index'
end
