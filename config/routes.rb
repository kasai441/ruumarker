# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'
  resources :rooms, except: %i[index edit create] do
    resources :maps, except: %i[index show destroy]
    resources :marks, except: :index
  end
  namespace :api do
    resources :maps, only: %i[show create update]
    resources :marks, only: %i[show create update]
  end
end
