Rails.application.routes.draw do
  resources :deals

  root 'welcome#index'
end
