Rails.application.routes.draw do
  get 'reports/index'
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
  get '/forms/training', to: 'trainings#new', as: 'trainings'
  post '/forms/training', to: 'trainings#create'
  get '/forms/street', to: 'street_swarms#new', as: 'street_swarms'
  post '/forms/street', to: 'street_swarms#create'
  get '/forms/arrestable', to: 'arrestable_actions#new', as: 'arrestable_actions'
  post '/forms/arrestable', to: 'arrestable_actions#create'
  get '/forms/mobilization', to: 'mobilizations#new', as: 'mobilizations'
  post '/forms/mobilization', to: 'mobilizations#create'

  get 'admins/index' => 'admins#index'

  get 'new_user' => 'users#new'

  get '/reports', to: 'reports#index', as: 'reports'
  get '/reports/tiles', to: 'reports#tiles', as: 'report_tiles'
  get '/reports/table', to: 'reports#table', as: 'report_table'
  get '/reports/:country', to: 'reports#index'
  get '/reports/:country/:state', to: 'reports#index'

  get '/locations/states', to: 'locations#states'
  get '/locations/cities', to: 'locations#cities'
end
