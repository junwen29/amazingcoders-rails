Rails.application.routes.draw do
  resources :qr_codes, only: [:new, :create]
  # root to: "qr_codes#new"

  resources :deals
  root 'welcome#index'
end
