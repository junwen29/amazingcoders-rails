Rails.application.routes.draw do

  resources :venues
  resources :charges
  resources :deals
  root 'welcome#index'
end
