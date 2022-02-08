# frozen_string_literal: true

Rails.application.routes.draw do
  # あとでやる：ルートをランダムURLにする方法
  root to: 'maps#new'
  resources :rooms
  resources :maps
end
