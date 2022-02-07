# frozen_string_literal: true

Rails.application.routes.draw do
  # あとでやる：ルートをランダムURLにする方法
  # root to: 'room#show'
  resources :rooms
end
