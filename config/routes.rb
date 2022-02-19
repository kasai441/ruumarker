# frozen_string_literal: true

Rails.application.routes.draw do
  # あとでやる：ルートをランダムURLにする方法
  root to: 'home#index'
  resources :rooms, except: %i[index edit create] do
    resources :maps, except: %i[index show destroy]
    resources :marks, except: :index
  end
end
