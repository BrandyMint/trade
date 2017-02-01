Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  root 'welcome#index'

  get 'signin', to: 'user_sessions#new'
  get 'signup', to: 'users#new'
  delete 'signout', to: 'user_sessions#destroy'

  resources :user_sessions, only: [:new, :create, :destroy]
  resources :users, only: [:create, :update, :new, :edit]

  resource :profile, controller: :profile
  resources :companies
  resources :company_goods
  resources :goods
  resources :password_resets, only: [:new, :create, :edit, :update]
end
