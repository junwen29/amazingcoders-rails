Rails.application.routes.draw do
  devise_for :users

################# Android
  namespace :api do
    namespace :p1 do
      devise_scope :user do
        scope '/accounts' do
          # post 'registrations' => 'registrations#create', :as => 'register'
          post '/sign_in' => 'sessions#create'
          delete '/sign_out' => 'sessions#destroy'
          post '/sign_up' => 'registrations#create'
        end
      end

      get 'tasks' => 'tasks#index', :as => 'tasks'

      # deals api
      get 'deals' => 'deals#index', :as => 'index'
      get 'venues' => 'venues#index', :as => 'venues'
      get 'venue_show/:id' => 'venues#show', :as => 'show'

      ## to register device token
      scope '/devices' do
        post '' => 'devices#create'
        delete '' => 'devices#destroy'
      end

      # TODO
      # get '/notifications' => "activities#notifications"
      # get '/notifications/count' => "activities#notification_count"

    end
  end

################## Burpple Admin
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)



################# Food Merchants
  devise_for :merchants, controllers: { sessions: "merchants/sessions", registrations: "merchants/registrations"}
  resources :venues
  resources :merchants

  resources :deals
  resources :payments do
    resources :charges
  end

# To change a deal into active deal then going back to index page
  get 'deals/:id/activate' => 'deals#activate', :as => 'active_deal'

# To push a deal then goes back to index page
  get 'deals/:id/push' => 'deals#push', :as => 'push_deal'

  get 'merchant_pages/home' => 'merchant_pages#home', :as => :merchant_home
  get 'merchant_pages/help' => 'merchant_pages#help', :as => :merchant_help

  resources :merchant_pages
  root :to => 'merchant_pages#home'
end

# The priority is based upon order of creation: first created -> highest priority.
# See how all your routes lay out with "rake routes".

# You can have the root of your site routed with "root"
# root 'welcome#index'

# Example of regular route:
#   get 'products/:id' => 'catalog#view'

# Example of named route that can be invoked with purchase_url(id: product.id)
#   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

# Example resource route (maps HTTP verbs to controller actions automatically):
#   resources :products

# Example resource route with options:
#   resources :products do
#     member do
#       get 'short'
#       post 'toggle'
#     end
#
#     collection do
#       get 'sold'
#     end
#   end

# Example resource route with sub-resources:
#   resources :products do
#     resources :comments, :sales
#     resource :seller
#   end

# Example resource route with more complex sub-resources:
#   resources :products do
#     resources :comments
#     resources :sales do
#       get 'recent', on: :collection
#     end
#   end

# Example resource route with concerns:
#   concern :toggleable do
#     post 'toggle'
#   end
#   resources :posts, concerns: :toggleable
#   resources :photos, concerns: :toggleable

# Example resource route within a namespace:
#   namespace :admin do
#     # Directs /admin/products/* to Admin::ProductsController
#     # (app/controllers/admin/products_controller.rb)
#     resources :products
#   end
