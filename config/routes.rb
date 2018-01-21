Rails.application.routes.draw do
  root "bookmarks#index"

  get "signup" => "signup#new"
  post "signup" => "signup#create"

  get "login" => "sessions#new"
  post "login" => "sessions#create"
  get "logout" => "sessions#destroy"

  get "dashboard" => "bookmarks#index"

  resources :bookmarks, except: [:index]
  resources :sites, only: [:index, :destroy]
  resources :tags, only: [:index, :destroy]
end
