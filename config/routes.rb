Rails.application.routes.draw do
  get 'password_resets/create'

  get 'password_resets/edit'

  get 'password_resets/update'

  root 'welcome#index'

  resources :companies
  resources :user_sessions, only: [:new, :create, :destroy]
  resources :users, only: [:create, :update, :new, :edit]
end
