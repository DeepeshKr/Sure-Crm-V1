Rails.application.routes.draw do



  #auto fill details from here
  resources :order_lines do
      get :autocomplete_product_variant_name, on: :collection
      get :autocomplete_product_variant_description, on: :collection
  end
 
    #get 'update_all_for_code' => 'product_masters#update_all_for_code'

    post 'updatedescription' => 'order_line#update_description'

    get 'neworder' => 'create_order#index'
    #post 'neworder' => 'create_order#index'
    post 'addcustomer' => 'create_order#add_customer'
    post 'addorder' => 'create_order#add_order'

    get 'showproducts' => 'create_order#show_products'
    post 'addproducts' => 'create_order#add_products'

    get 'showaddress' => 'create_order#show_address'
    post 'addaddress' => 'create_order#add_address'
    post 'updateaddress' => 'create_order#update_address'

    get 'showaddonproducts' => 'create_order#show_addonproducts'
    post 'addaddonproducts' => 'create_order#show_addonproducts'

    get 'showpayment' => 'create_order#show_payment'
    post 'addpayment' => 'create_order#add_payment'
    post 'addcard' => 'create_order#add_credit_card'

    get "creditcardvalid" => 'customer_credit_cards#luhn'
    get "creditcardtype" => 'customer_credit_cards#card_type'

    get 'showmedia' => 'create_order#show_media'
    post 'addmedia' => 'create_order#add_media'

    get 'orderreview' => 'create_order#order_review'
    post 'orderprocess' => 'create_order#order_process'

    get 'ordersummary' => 'create_order#order_summary'

    get 'recentorders' => 'create_order#show_recentorders'

    get 'create' => 'customers#createnew'
    post   'add' => 'customers#add'

    get 'createc' => 'corporates#createnew'
    post   'addc' => 'corporates#add'

    post 'addmedia_togroup' => 'media_groups#addmedia'
    post 'addmedia_tocomission' => 'media_commisions#addmedia'
    
    get 'address_dealer/list'
    get 'newdealer' =>  'address_dealer#new_dealer'
    post 'newdealerenquiry' =>  'address_dealer#dealer_enquiry'

    get 'interaction' => 'interaction_masters#index'
    get 'newinteraction' => 'interaction_masters#new_ticket'
    post 'newticket' => 'interaction_masters#new_interaction'
    post 'newcomments' => 'interaction_transcripts#quick_create'

    get 'corporateorder/list'
    get 'corporateorder/new'
    get 'corporateorder/create'
    get 'corporateorder/products'
    get 'corporateorder/payment'
    get 'corporateorder/review'
    get 'corporateorder/process'

    get 'b_prodmaster/list'
    get 'b_prodmaster/search'
    get 'b_prodmaster/details'
    get 'bprodmaster' => 'b_prodmaster#list'

    get 'product_upsell/list'
    get 'product_upsell/search'
    get 'product_upsell/details'
     get 'product_upsell' => 'product_upsell#details'
    get 'productupsell' => 'product_upsell#list'

    get 'productreport' => 'product_report#list'
    get 'product_report/search'
    get 'productdetails' => 'product_report#details'

    get 'product_cost/list'
    get 'product_cost/cost'
    get 'product_cost/search'
    get 'product_cost/details'
    get 'productcost' => 'product_cost#details'

    resources :user_roles
    resources :customer_order_lists

mount Upmin::Engine => '/admin'
  resources :corporate_types, :media_commisions, :product_sell_types, :product_variant_add_ons
  resources :order_fors, :media_groups,  :create_order , :order_payments
  resources :media_groups, :media_commisions, :customer_credit_cards, :change_log_trails, :change_log_types
  resources :order_masters, :order_lines, :orderpaymentmodes, :interaction_transcripts, :interaction_masters
  resources :product_training_manuals, :campaign_playlists, :product_variants, :product_masters  
  resources :media, :campaigns, :bills, :order_sources, :customers
  resources :customer_addresses, :address_valids, :address_types, :interaction_categories
  resources :campaign_stages, :product_types, :product_categories, :interaction_priorities
  resources :corporates, :product_warehouses, :interaction_statuses, :interaction_users
  resources :employees, :users, :sessions, :product_active_codes, :states
  resources :salutes, :employment_types, :employee_roles, :order_line_dispatch_statuses
  resources :order_status_masters, :product_training_headings, :product_inventory_codes


  #root             'product#home'
  root 'project#home'
  get 'help'    => 'product#help'
  get 'about'   => 'product#about'
  get 'contact' => 'product#contact'

  get 'dealers' => 'address_dealer#list'
 
  get 'oldhelp'    => 'project#help'
  get 'oldabout'   => 'project#about'
  get 'oldcontact' => 'project#contact'
  #get 'dropdown' => 'project#dropdown'
  #get "project/update_text", as: "update_text"
  get "productdetails" => 'product_masters#details'
  get "producttraining" => 'product_training_manuals#training'
   get "productvariant" => 'product_variant#details'
  #get "creditcard" => 'project#luhn'

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
