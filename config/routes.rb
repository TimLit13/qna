Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  concern :votable do
    member do
      put :rate_up
      put :rate_down
      delete :cancel_rate
    end
  end

  resources :questions, concerns: [:votable] do
    resources :answers, concerns: [:votable], shallow: true do
      patch :mark_answer_as_best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :awards, only: :index
end
