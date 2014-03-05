InGameAudio::Application.routes.draw do

  resources :songs
  resources :directories

  root to: "directories#index"

  namespace :v1, defaults: {format: 'json'} do
    resources :api do
      post 'song_query', on: :collection
    end
  end
  
end
