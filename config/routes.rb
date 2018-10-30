Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'users/show'
  get 'users/edit'
  get 'users/update'
  get 'users/delete'
  get 'places/search'
  get 'places/index'
  get 'places/show'
  get 'places/update'
  get 'places/edit'
  get 'places/create'
  root 'places#search'
  namespace :admin do
    get 'pages/index'
    get 'pages/edit'
    get 'pages/update'
    get 'pages/delete'
    get 'pages/show'
  end
  namespace :admin do
    get 'users/index' => 'users#index'
    get 'users/edit'
    get 'users/update'
    get 'users/delete'
  end
end
