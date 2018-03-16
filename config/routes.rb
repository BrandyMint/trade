require 'sidekiq/web'
Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]

require 'admin_constraint'

Rails.application.routes.draw do

  root 'welcome#index'

  post 'supersignin', to: 'user_sessions#supersignin', as: :supersignin

  mount Sidekiq::Web, at: '/sidekiq', :constraints => AdminConstraint.new

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  get 'signin', to: 'user_sessions#new'
  get 'signup', to: 'users#new'
  delete 'signout', to: 'user_sessions#destroy'

  resources :user_transactions, only: [:index, :new, :show]
  resources :user_sessions, only: [:create]
  resources :users, only: [:create, :update, :new, :edit]


  resource :password, only: [:edit, :update]

  resources :pages, only: [:show]

  resources :companies do
    resources :outcome_orders, shallow: true
    member do
      put :done
    end
    resources :company_documents do
      collection do
        delete :delete_by_name
      end
    end
  end

  resources :user_orders
  resources :user_transactions
  resources :user_goods
  resources :user_companies, only: [:index] do
    member do
      get :income
      get :outcome
    end
  end

  resources :banners, only: [:destroy]

  resources :orders
  resources :goods
  resources :password_resets, only: [:new, :create, :edit]

  get 'unsubscribe/:token', to: 'welcome#unsubscribe', as: :unsubscribe

  namespace :admin do
    root 'dashboard#index'
    resources :transactions
    resources :outcome_orders, only: [:index, :show] do
      member do
        patch :accept
        patch :reject
      end
    end
    resources :users
    resources :pages
    resources :banners
    resources :goods
    resources :orders do
      member do
        patch :complete
        patch :cancel
      end
    end
    resources :lockings
    resources :users
    resources :companies do
      member do
        patch :rework
        patch :start_review
        patch :accept
        patch :reject
      end
      resources :transactions, controller: 'company_transactions'
    end
  end

  get "error" => "errors#show", :as => "error"
  %w( 404 422 500 ).each do |code|
    get code, :to => "errors#show", :code => code
  end

  get '*anything', to: 'errors#show', code: 404
end
