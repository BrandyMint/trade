Rails.application.routes.draw do
  root 'welcome#index'

  get 'signin', to: 'user_sessions#new'
  get 'signup', to: 'users#new'
  delete 'signout', to: 'user_sessions#destroy'

  resources :user_sessions, only: [:new, :create, :destroy]
  resources :users, only: [:create, :update, :new, :edit]

  resource :profile, controller: :profile
  resources :companies do
    member do
      put :done
    end
    resources :company_documents
    resources :company_goods
  end

  namespace :user do
    resources :goods
  end
  resources :user_companies, only: [:index]
  resources :categories, only: [:show, :index]
  resources :goods
  resources :password_resets, only: [:new, :create, :edit, :update]

  namespace :admin do
    root 'dashboard#index'
    resources :companies
  end
end
