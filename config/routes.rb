Rails.application.routes.draw do

  devise_for :logins
#sales report 
  get 'sales_report' => 'sales_report#summary' 
  get 'sales_report/summary'
  get 'sales_report/hourly'
  get 'hourly_report' => 'sales_report#hourly'
  get 'sales_report/daily'
  get 'sales_report/channel'
  get 'channel_report' => 'sales_report#channel'
  get 'sales_report/employee'
  get 'employee_report' => 'sales_report#employee'
  get 'sales_report/product'
  get 'product_report' => 'sales_report#product'
  get 'sales_report/show'

  resources :media_tape_heads

  resources :india_city_lists

  get 'tempinv_newwlsdet/list'
  get 'tempinv_newwlsdet/search'
  get 'tempinv_newwlsdet/details'
  get 'custdetailsreport' => 'custdetails#list'
  get 'custdetails/list'
  get 'custdetails/search'
  # get 'custordersearch' => 'custdetails#search'
  get 'custordersearch' => 'order_masters#search'
  get 'custdetails/details'
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
  get 'dnismaster/list'
  get 'dnismaster/search'
  get 'dnismaster/details'

  get 'stockbook' => 'product_stock_books#index'

   resources :india_city_lists  
  resources :india_pincode_lists

  resources :india_city_lists do
    get :autocomplete_india_city_list_name, :on => :collection
  end

  resources :india_pincode_lists do
    collection { post :import }
    get :autocomplete_india_pincode_list_pincode, :on => :collection
    get :autocomplete_india_pincode_list_taluk, :on => :collection
     get :autocomplete_india_pincode_list_officename, :on => :collection
    get :autocomplete_india_pincode_list_districtname, :on => :collection
    get :autocomplete_india_pincode_list_regionname, :on => :collection

  end

  #auto fill details from here
  resources :order_lines do
      get :autocomplete_india_pincode_list_pincode, :on => :collection
      get :autocomplete_india_pincode_list_taluk, :on => :collection
      get :autocomplete_india_pincode_list_officename, :on => :collection
      get :autocomplete_india_pincode_list_districtname, :on => :collection
      get :autocomplete_india_pincode_list_regionname, :on => :collection
      get :autocomplete_india_city_list_name, :on => :collection

      get :autocomplete_product_variant_name, on: :collection
      get :autocomplete_product_variant_description, on: :collection
      get :autocomplete_product_list_name, on: :collection
  end

  

  resources :product_stock_books
  resources :product_stock_adjusts
  resources :product_stocks
  resources :product_master_add_ons
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


 
  #step 1
  get 'neworder' => 'customerorder#newcall'
  get 'update_product_list' => 'customerorder#update_product_list'
  get 'products' => 'customerorder#products'
  get 'offline' => 'customerorder#offline'
  post 'uploadcall' => 'customerorder#uploadcall'
  post 'addproducts' => 'customerorder#add_products'
  post 'addbasicupsellproducts' => 'customerorder#add_basic_upsell'
 
  #step 2
  get 'address' => 'customerorder#address'
  post 'addaddress' => 'customerorder#add_address'
  post 'updatecustomer' => 'customers#update_customer'
    #step 3
  get 'upsell' => 'customerorder#upsell'
  post 'addupsell' => 'customerorder#add_upsell'
  get 'deleteupsell' => 'order_lines#deleteupsell'
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

  get 'orderlist' => 'order_masters#list'

  get 'dailyreport' => 'order_masters#daily_report'
  
  get 'dailyschedule' => 'campaign_playlists#perday' 
  #other activities
  get 'dealersearch' => 'customerorder#dealers'
  get 'newdealer' =>  'customerorder#new_dealer'

  post 'inoracle' => 'customer_order_lists#inoracle'

  get 'producttraininglist' => 'product_training_manuals#index'
  post 'inlinetraining' => 'product_training_manuals#inlinecreate'
  # get 'dealersearch' => 'address_dealer#list'
  # get 'newdealer' =>  'address_dealer#new_dealer'

  post 'newdealerenquiry' =>  'address_dealer#dealer_enquiry'
  post 'updatestockbook' => 'product_stock_books#create'
  #this is a duplication of interaction below
  post 'disposition' => 'customerorder#new_interaction'
  #post 'disposition' => 'interaction_masters#new_interaction'
    #get 'update_all_for_code' => 'product_masters#update_all_for_code'

  post 'updatedescription' => 'order_line#update_description'

  get 'update_tapes' => 'media_tape_heads#update_tapes'
  get 'tape_list' => 'media_tape_heads#tape_list'

  #post 'campaign_playlists/create_playlist_with_media_tape_head'
  post 'create_playlist' => 'campaign_playlists#create_playlist_with_media_tape_head'
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
     #stock report opening stock
    get 'openingstockreport' => 'product_report#opening_stock_report'
     #stock report purchases
    get 'purchasedstockreport' => 'product_report#purchased_stock_report'
     #stock report retail returns
    get 'retailreturnedreport' => 'product_report#retail_returned_stock_report'

    #stock report retail sold
    get 'retailsoldreport' => 'product_report#retail_sold_stock_report'
    #stock report wholesale sold
    get 'wholesalesoldreport' => 'product_report#wholesale_sold_stock_report'
    #stock report branch sold
    get 'branchsoldreport' => 'product_report#branch_sold_stock_report'

    #stock correction report
    get 'correctionstockreport' => 'product_report#corrections_stock_report'



    get 'product_cost/list'
    get 'product_cost/cost'
    get 'product_cost/search'
    get 'product_cost/details'
    get 'productcost' => 'product_cost#details'
    
    delete 'deleteproductstock' => 'product_stocks#destroy'
    # get 'deleteproductstock' => 'product_stocks#deletestock'
    delete 'deleteproductstockadjust' => 'product_stock_adjusts#delete'



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
  get "producttraining_text" => 'product_training_manuals#training_text'  
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

 
end
