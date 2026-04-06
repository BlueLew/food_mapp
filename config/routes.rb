Rails.application.routes.draw do
  mount MissionControl::Jobs::Engine, at: "/jobs"

  namespace :admin do
    resources :venues
    resources :users, only: %i[index show edit update destroy]
  end

  resource :registration, only: %i[new create]
  resource :profile, only: %i[show edit update]
  resources :residences, except: :show
  resources :venues, only: %i[index show] do
    resource :like, only: %i[create destroy]
  end
  resource :session, only: %i[new create destroy]
  resources :passwords, only: %i[new create edit update], param: :token

  get "up" => "rails/health#show", as: :rails_health_check

  root "venues#index"
end
