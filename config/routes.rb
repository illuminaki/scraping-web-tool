# frozen_string_literal: true

Rails.application.routes.draw do
  resources :sent_emails
  resources :registers

  resources :lists do
    member do
      post :start_scraping
      get :generate_excel
      post :import_txt
      post :send_email
    end
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Root path
  root "lists#index"
end
