Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }

  resources :users
  resources :chapters
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  authenticated :user, ->(u) { u.role == 'external' } do
    root to: "chapters#current_user_chapter", as: :external_root
  end

  authenticated :user, ->(u) { u.role == 'admin' } do
    root to: "admins#index", as: :admins_root
  end

  root to: "home#index"

  get '/forms/index' => 'forms#index'
  get '/forms/mobilization' => 'forms#mobilization'
  get '/forms/training', to: 'trainings#new', as: 'trainings'
  post '/forms/training', to: 'trainings#create'
  get '/forms/arrestable' => 'forms#arrestable'
  get '/forms/street', to: 'street_swarms#new', as: 'street_swarms'
  post '/forms/street', to: 'street_swarms#create'

  get 'admins/index' => 'admins#index'

  get  'new_user' => 'users#new'
end
