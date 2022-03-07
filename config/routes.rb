Rails.application.routes.draw do
  get 'sessions/new'
  get 'sessions/create'
  get 'sessions/destroy'
  resources :users

  resources :sessions, only: [:new, :create, :destroy]

  resources :microposts, only: [:create, :destroy]

  resources :relationships, only: [:create, :destroy]


  root "staticpages#home"

  get '/home', to: 'staticpages#home'
  get '/about', to: 'staticpages#about'
  get '/contact', to: 'staticpages#contact'
  get '/signup', to: 'users#new'

  get '/login', to: 'sessions#new'
  delete '/logout', to: 'sessions#destroy'

  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :microposts do
    member do
      get :like, :dislike
    end
  end
  
end
