Rails.application.routes.draw do

  get 'newwlsdet/list'

  get 'newwlsdet/search'

  get 'newwlsdet/details'

  get 'purchases_new/list'

  get 'purchases_new/search'

  get 'purchases_new/details'

  get 'vpp/list'

  get 'vpp/search'

  get 'vpp/details'

  get 'customerorder/products'
  get 'customerorder/address'
  get 'customerorder/payment'
  get 'customerorder/channel'
  get 'customerorder/review'
  get 'customerorder/summary'

  resources :product_master_add_ons

  get 'dnismaster/list'
  get 'dnismaster/search'
  get 'dnismaster/details'

  resources :campaign_play_list_statuses
  resources :product_lists
  resources :media_cost_masters
  resources :product_spec_lists
  resources :media_tapes
 
  get 'tapeiddet/list'
  get 'tapeiddet/search'
  get 'tapeiddet/details'
  get 'tapeids/list'
  get 'tapeids/search'
  get 'tapeids/details'
  get 'purchase/list'
  get 'purchase/search'
  get 'purchase/details'

  #auto fill details from here
  resources :order_lines do
      get :autocomplete_product_variant_name, on: :collection
      get :autocomplete_product_variant_description, on: :collection
      get :autocomplete_product_list_name, on: :collection
  end
 
  #step 1
  get 'neworder' => 'customerorder#products'
  post 'addproducts' => 'customerorder#add_products'
  post 'addbasicupsellproducts' => 'customerorder#add_basic_upsell'
 
  #step 2
  get 'address' => 'customerorder#address'
  post 'addaddress' => 'customerorder#add_address'
  post 'updatecustomer' => 'customers#update_customer'
    #step 3
  get 'upsell' => 'customerorder#upsell'
  post 'addupsell' => 'customerorder#add_upsell'
  
  #step 3
  get 'payment' => 'customerorder#payment'
  post 'addpayment' => 'customerorder#add_payment'
  post 'addcard' => 'customerorder#add_credit_card'
  get "creditcardvalid" => 'customer_credit_cards#luhn'
  get "creditcardtype" => 'customer_credit_cards#card_type'
  
  #step 4
  get 'channel' => 'customerorder#channel'
  post 'addchannel' => 'customerorder#add_channel'

  
  get  'playlistvariant' => 'campaign_playlists#showproductvariant'
  post 'playlistupdatevariant' => 'campaign_playlists#updateproductvariant'

  #step 5
  get 'review' => 'customerorder#review'
  #step 6
  post 'processorder' => 'customerorder#process_order'
  get 'summary' => 'customerorder#summary'


  get 'dailyschedule' => 'campaign_playlists#perday' 
  #other activities
  get 'dealersearch' => 'customerorder#dealers'
  get 'newdealer' =>  'customerorder#new_dealer'

  # get 'dealersearch' => 'address_dealer#list'
  # get 'newdealer' =>  'address_dealer#new_dealer'

  post 'newdealerenquiry' =>  'address_dealer#dealer_enquiry'

  #this is a duplication of interaction below
  post 'disposition' => 'customerorder#new_interaction'
  #post 'disposition' => 'interaction_masters#new_interaction'
    #get 'update_all_for_code' => 'product_masters#update_all_for_code'

  post 'updatedescription' => 'order_line#update_description'

  #post 'neworder' => 'create_order#index'

  #get 'recentorders' => 'create_order#show_recentorders'

    get 'create' => 'customers#createnew'
    post   'add' => 'customers#add'

    get 'createc' => 'corporates#createnew'
    post   'addc' => 'corporates#add'

    post 'addmedia_togroup' => 'media_groups#addmedia'
    post 'addmedia_tocomission' => 'media_commisions#addmedia'
    
    # get 'address_dealer/list'
    # get 'newdealer' =>  'address_dealer#new_dealer'
    # post 'newdealerenquiry' =>  'address_dealer#dealer_enquiry'

    get 'interaction' => 'interaction_masters#index'
    get 'newinteraction' => 'interaction_masters#new_ticket'
    post 'newticket' => 'interaction_masters#new_interaction'
     post 'disposecall' => 'interaction_masters#dispose_call'
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

    get 'duplicate_playlist' => 'campaign_playlists#duplicate'
    post 'create_duplicate_playlist' => 'campaign_playlists#create_duplicate'

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
  resources :product_training_manuals, :product_variants, :product_masters  
  resources :media, :campaigns, :bills, :order_sources, :customers
  resources :customer_addresses, :address_valids, :address_types, :interaction_categories
  resources :campaign_stages, :product_types, :product_categories, :interaction_priorities
  resources :corporates, :product_warehouses, :interaction_statuses, :interaction_users
  resources :employees, :users, :sessions, :product_active_codes, :states
  resources :salutes, :employment_types, :employee_roles, :order_line_dispatch_statuses
  resources :order_status_masters, :product_training_headings, :product_inventory_codes

  #resources :campaign_playlists, :collection => { :edit_individual => :post, :update_individual => :put }
  resources :campaign_playlists

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
  get "productvariantdetails" => 'product_variants#details'
  get "productvariantcombined" => 'product_variants#combined'
  get "mediatapesforproducts" => 'media_tapes#productwise'
  get "mediatapesdetails" => 'media_tapes#tape_details'
  get "addonproductlist" => 'media_tapes#product_lists'
  get "addonproductlist" => 'product_master_add_ons#product_lists'
#addonproducts
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

  #**************************************
    #******* order process start **********
    #**************************************

    #order process is listed below is this is no longer users
    #get 'neworder' => 'create_order#index'
    # post 'addcustomer' => 'create_order#add_customer'
    # post 'updatecustomer' => 'customers#update_customer'
    # post 'addorder' => 'create_order#add_order'

    # get 'showproducts' => 'create_order#show_products'
    # post 'addproducts' => 'create_order#add_products'

    # get 'showaddress' => 'create_order#show_address'
    # post 'addaddress' => 'create_order#add_address'
    # post 'updateaddress' => 'create_order#update_address'

    #get 'showaddonproducts' => 'create_order#show_addonproducts'
    #post 'addaddonproducts' => 'create_order#add_addonproducts'

    # get 'showpayment' => 'create_order#show_payment'
    

    

    # get 'showmedia' => 'create_order#show_media'
    # post 'addmedia' => 'create_order#add_media'

    # get 'orderreview' => 'create_order#order_review'
    # post 'orderprocess' => 'create_order#order_process'

    # get 'ordersummary' => 'create_order#order_summary'

    #**********************
    #******* order process end *********
    #**************************

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
