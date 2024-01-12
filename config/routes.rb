Rails.application.routes.draw do
  resources :votes, only: [:new, :create, :show, :index]
  resources :candidates, only: :create
  resources :sessions, only: [:new, :create, :destroy]

  root "index#index"
end
