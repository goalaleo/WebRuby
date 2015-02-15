Ratebeer::Application.routes.draw do
  resources :memberships

  resources :beer_clubs

  resources :users

  resources :beers

  resources :breweries

  resources :ratings, only: [:index,:new,:create,:destroy]

  resource :session, only: [:new,:create,:delete]

  root 'breweries#index'

  get 'kaikki_bisset', to: 'beers#index'

  get 'signup', to: 'users#new'

  get 'signin', to: 'sessions#new'

  delete 'signout', to: 'sessions#destroy'




end
