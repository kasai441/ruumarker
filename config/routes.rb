# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'
  resources :rooms, only: %i[new show destroy] do
    resources :maps, only: :edit
    resources :marks, only: %i[new edit destroy]
    resources :reports, only: :index
  end
  namespace :api do
    resources :rooms, only: '' do
      resources :maps, only: %i[create update]
      resources :marks, only: %i[create update]
    end
  end
end
