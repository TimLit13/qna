require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  root to: "questions#index"

  namespace :users do
    resource :oauth_email_confirmations, only: %i[new create]
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
        get :all, on: :collection
      end

      resources :questions, only: %i[index show create update destroy] do
        resources :answers, only: %i[index show create update destroy]
      end
    end
  end

  concern :votable do
    member do
      put :rate_up
      put :rate_down
      delete :cancel_rate
    end
  end

  concern :commentable do
    resource :comments, only: :create
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, concerns: [:votable, :commentable], shallow: true do
      patch :mark_answer_as_best, on: :member
    end
    resources :subscriptions,only: [:create, :destroy], shallow: true
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index

  mount ActionCable.server => '/cable'
end
