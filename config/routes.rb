InGameAudio::Application.routes.draw do

  resources :songs
  resources :directories
  resources :api_keys

  resources :users do
    post 'ban', on: :member
    post 'unban', on: :member
    post 'approve', on: :member
    post 'unapprove', on: :member
  end

  root to: "directories#index"

  namespace :v1, defaults: {format: 'json'} do
    resources :api do
      post 'song_query', on: :collection
    end
  end

  match "/auth/steam/callback" => "sessions#create", via: [:get, :post], as: :login
  get "/logout" => "sessions#destroy", as: :logout
  
end
