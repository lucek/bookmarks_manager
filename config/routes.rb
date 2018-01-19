Rails.application.routes.draw do
  root "sessions#new"

  get "signup" => "signup#new"
  post "signup" => "signup#create"

  get "login" => "sessions#new"
  post "login" => "sessions#create"
  get "logout" => "sessions#destroy"

  get "dashboard" => "dashboard#index"
end
