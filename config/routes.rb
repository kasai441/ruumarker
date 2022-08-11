# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'
  resources :home, only: :index
  resources :help, only: :index
  resources :rooms, only: %i[new show] do
    resources :maps, only: :edit
    resources :marks, only: :edit
    resources :reports, only: :index
  end
  namespace :api do
    resources :rooms, only: :create do
      resources :maps, only: :update
      resources :marks, only: %i[create update destroy]
    end
  end

end
