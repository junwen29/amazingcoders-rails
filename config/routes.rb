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
      scope '/deals' do
        get '' => 'deals#index', :as => 'deals'
        get 'venues/:id' => 'venues#get_venues_for_deal', :as => 'get_venues_for_deal'

        scope '/:id' do
          get ''  => 'deals#get_deal', :as => 'get_deal'


          # bookmark api
          post    '/bookmarks' => "bookmarks#create"
          delete  '/bookmarks' => "bookmarks#destroy"
        end
      end

      # venues api
      scope '/venues' do
        get '' => 'venues#index', :as => 'venues'
        #### TODO change this route or fetching of venues should include associated json deals
        get '/deals/:id' => 'deals#get_deals_for_venue', :as => 'get_deals_for_venue'

        scope '/:id' do
          get ''=> 'venues#get_venue', :as => 'get_venue'


          # wish api
          #get     '/wishes' => "wishes#wishes_by_venue" # based on venue
          post    '/wishes' => "wishes#create"
          delete  '/wishes' => "wishes#destroy"

        end
      end

      ## to register device token
      scope '/devices' do
        post '' => 'devices#create'
        delete '' => 'devices#destroy'
      end

      # TODO notifications
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
  resources :points
  resources :packages

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
