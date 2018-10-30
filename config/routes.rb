Rails.application.routes.draw do


  get "client-login", to: "reserver_sessions#new"
  get "client-logout", to: "reserver_sessions#destroy"

  get "client-signup", to: "reservers#new"

  root "static_pages#home"
  get '/about', to: "static_pages#about"
  get '/house', to: "static_pages#house"
  get '/location', to: "static_pages#location"
  get '/enquire', to: "static_pages#enquire"
  get '/reservations-search', to: "reservations#search"
  get '/reservers-search', to: "reservers#search"
  resources :reservations
  resources :reservers
  resources :calendar
  resources :admins
  resources :reserver_sessions
end
