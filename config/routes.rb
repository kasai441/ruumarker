# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'
  resources :rooms, except: %i[index edit create] do
    resources :maps, except: %i[index show destroy]
    resources :marks, except: :index
  end
  scope :api do
    resources :maps, only: %i[create update]
    resources :marks, only: %i[create update]
  end
end
