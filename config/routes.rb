Rails.application.routes.draw do
  root 'welcome#index'

  resources :companies

  get 'signin', to: 'user_sessions#new'
  get 'signup', to: 'users#new'

  delete 'signout', to: 'user_sessions#destroy'

  resources :password_resets, only: [:new, :create, :edit, :update]

  resources :user_sessions, only: [:new, :create, :destroy]

  resources :users, only: [:create, :update, :new, :edit]
end
