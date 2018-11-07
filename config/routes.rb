Rails.application.routes.draw do
  get 'locations/index'
  get 'locations/show'
  get 'location/index'
  get 'location/show'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users, only: [:show, :edit, :update]
  resources :places, except: [:delete, :destroy]
  #get 'places/new' => 'places#create'
  #get 'places/index'
  #get 'places/show' => 'places#show'
  #get 'places/update'
  #get 'places/edit'
  #get 'places/create'
  root 'places#index'
  namespace :admin do
    get 'users/index' => 'users#index'
    get 'users/edit'
    get 'users/update'
    get 'users/delete' 
    get 'places/index'
    get 'places/edit'
    get 'places/update'
    get 'places/delete'
  end

end
