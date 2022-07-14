# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'
  resources :home, only: :index
  resources :help, only: :index
  resources :rooms, only: %i[new show] do
    resources :maps, only: :edit
    resources :marks, only: %i[new edit]
    resources :reports, only: :index
  end
  namespace :api do
    resources :rooms, only: '' do
      resources :maps, only: %i[create update]
      resources :marks, only: %i[update destroy]
    end
  end

end
