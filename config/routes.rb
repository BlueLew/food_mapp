Rails.application.routes.draw do
  devise_for :users
  resources :users

  resources :locations

  resources :places do
    resources :likes
  end
  root 'places#index'

  namespace :admin do
    resources :places, except: :create
    resources :users, except: :create
    # get 'users' => 'users#index'
    # get 'users/edit'
    # get 'users/update'
    # get 'users/delete'
    # get 'places' => 'places#index'
    # get 'places/edit'
    # get 'places/update'
    # get 'places/delete'
  end
end
