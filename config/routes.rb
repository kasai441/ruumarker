# frozen_string_literal: true

Rails.application.routes.draw do
  # あとでやる：ルートをランダムURLにする方法
  root to: 'rooms#new'
  resources :rooms, except: %i[index] do
    resources :maps, except: %i[index destroy]
  end
end
