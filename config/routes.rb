Rails.application.routes.draw do

  devise_for :admins
  root "static_pages#home"
  get '/about', to: "static_pages#about"
  get '/house', to: "static_pages#house"
  get '/location', to: "static_pages#location"
  get '/enquire', to: "static_pages#enquire"
  resources :reservations
  resources :reservers
  resources :calendar
end
