Rails.application.routes.draw do

  resources :charges
  resources :deals

  root 'welcome#index'
end
