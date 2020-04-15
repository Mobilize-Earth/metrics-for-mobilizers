Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations'
  }

  resources :users
  resources :chapters
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  authenticated :user, ->(u) { u.role == 'external' } do
    root to: "dashboard#index", as: :external_root
  end

  authenticated :user, ->(u) { u.role == 'admin' } do
    root to: "admins#index", as: :admins_root
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
