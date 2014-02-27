InGameAudio::Application.routes.draw do

  resources :songs
  resources :directories

  root to: "directories#index"
  
end
