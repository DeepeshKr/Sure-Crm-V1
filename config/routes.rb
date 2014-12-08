Rails.application.routes.draw do
  resources :bills

  resources :order_sources

  resources :customers

  resources :customer_addresses

  resources :address_valids

  resources :address_types

  resources :interaction_categories

  resources :campaign_stages

  resources :product_types

  resources :product_categories

  resources :interaction_priorities

  resources :corporates

  resources :product_warehouses

  resources :interaction_statuses

  resources :interaction_users

  resources :employees

  resources :users  
  resources :sessions
  resources :salutes
  resources :employment_types
  resources :employee_roles
  resources :order_line_dispatch_statuses
  resources :order_status_masters
  resources :product_training_headings
  resources :product_inventory_codes
  resources :product_active_codes
  resources :states

  #root             'product#home'
  root 'product#home'
  get 'help'    => 'product#help'
  get 'about'   => 'product#about'
  get 'contact' => 'product#contact'
  get 'signup'  => 'users#new'

  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  #setup pages
 # get    'salutes'   => 'salutes'
  #get    'states'   => 'states#index'
 # get    'employment_types'   => 'employment_types#index'
  #get    'employee_roles'   => 'employee_roles#index'
 # get    'order_line_dispatch_statuses'   => 'order_line_dispatch_statuses#index'
 # get    'order_status_masters'   => 'order_status_masters#index'
 # get    'product_training_headings'   => 'product_training_headings#index'
 # get    'product_inventory_codes'   => 'product_inventory_codes#index'
 # get    'product_active_codes'   => 'product_active_codes#index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"


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
end
