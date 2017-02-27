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

  resources :user_goods
  resources :user_companies, only: [:index]

  resources :banners, only: [:destroy]

  resources :orders
  resources :goods
  resources :password_resets, only: [:new, :create, :edit, :update]

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
