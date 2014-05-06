InGameAudio::Application.routes.draw do

  resources :songs do
    get 'play', on: :member
    get 'play_html5', on: :member
  end

  resources :directories do
    resources :songs, only: [:index]
  end

  resources :api_keys

  resources :users do
    resources :themes
    resources :songs, only: [:index]
    post 'ban', on: :member
    post 'unban', on: :member
    post 'authorize', on: :member
    post 'unauthorize', on: :member
  end


  namespace :v1, defaults: {format: 'json'} do
    resources :api do
      post 'query_song', on: :collection
      post 'user_theme', on: :collection
      post 'map_theme', on: :collection
      post 'authorize_user', on: :collection
      post 'search_song', on: :collection
    end
  end

  root to: "pages#home"

  get 'home', to: 'pages#home', as: 'home'
  get 'help', to: 'pages#help', as: 'help'
  get 'contact', to: 'pages#contact', as: 'contact'
  get 'stop', to: 'pages#stop', as: 'stop'
  get 'admin', to: 'pages#admin', as: 'admin'
  get 'statistics', to: 'pages#statistics', as: 'statistics'

  match "/auth/steam/callback" => "sessions#create", via: [:get, :post], as: :login
  get "/logout" => "sessions#destroy", as: :logout
  
end
