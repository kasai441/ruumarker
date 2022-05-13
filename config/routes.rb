# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'
  resources :rooms, only: %i[new show destroy] do
    resources :maps, only: :edit
    resources :marks, only: %i[new edit destroy]
  end
  namespace :api do
    resources :rooms, only: '' do
      resources :maps, only: %i[show create update]
      resources :marks, only: %i[show create update]
    end
  end
end
