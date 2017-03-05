require 'sidekiq/web'
Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]

require 'admin_constraint'

Rails.application.routes.draw do
  root 'welcome#index'

  mount Sidekiq::Web, at: '/sidekiq', :constraints => AdminConstraint.new

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  get 'signin', to: 'user_sessions#new'
  get 'signup', to: 'users#new'
  delete 'signout', to: 'user_sessions#destroy'

  resources :user_sessions, only: [:create]
  resources :users, only: [:create, :update, :new, :edit]

  resource :password, only: [:edit, :update]

  resources :companies do
    member do
      put :done
    end
    resources :company_documents
  end

  resources :user_goods
  resources :user_companies, only: [:index]

  resources :banners, only: [:destroy]

  resources :orders
  resources :goods
  resources :password_resets, only: [:new, :create, :edit]

  namespace :admin do
    root 'dashboard#index'
    resources :transactions
    resources :banners
    resources :lockings do
      member do
        patch :accept
        patch :reject
      end
    end
    resources :users do
      member do
        post :signin
      end
    end
    resources :companies do
      member do
        patch :start_review
        patch :accept
        patch :reject
      end
      resources :transactions, controller: 'company_transactions'
    end
  end
end
