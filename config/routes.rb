InGameAudio::Application.routes.draw do

  resources :songs do
    get 'play', on: :member
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

  root to: "directories#index"

  namespace :v1, defaults: {format: 'json'} do
    resources :api do
      post 'query_song', on: :collection
      post 'user_theme', on: :collection
      post 'map_theme', on: :collection
      post 'authorize_user', on: :collection
    end
  end

  match "/auth/steam/callback" => "sessions#create", via: [:get, :post], as: :login
  get "/logout" => "sessions#destroy", as: :logout
  
end
