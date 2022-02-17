# frozen_string_literal: true

Rails.application.routes.draw do
  get 'marks/new'
  get 'marks/create'
  get 'marks/edit'
  get 'marks/update'
  get 'marks/destroy'
  # あとでやる：ルートをランダムURLにする方法
  root to: 'rooms#new'
  resources :rooms, except: %i[index edit create] do
    resources :maps, except: %i[index show destroy]
    resources :marks, except: :index
  end
end
