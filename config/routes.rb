# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'registrations'
  }

  authenticated :user do
    root to: 'passthrough#index'
    resources :accounts, only: %i[new create show edit update destroy] do
      resources :users, only: %i[new create]
      resources :twilio_accounts, only: %i[new create destroy edit update]
      resources :function_logs, only: %i[index]
      resources :alerts, only: %i[index]
      resources :conversations, only: %i[index]
      resources :numbers, only: %i[index update]
      resources :memberships, only: %i[destroy]
      resources :calls, only: [:index] do
        collection do
          get :export
        end
      end
    end

    resources :feedback, only: %i[new create]
    resources :users, only: %i[edit update destroy]
  end

  get '/', to: redirect('/users/sign_up')
  get '*path', to: redirect('/users/sign_in')
end
