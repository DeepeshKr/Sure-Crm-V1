Rails.application.routes.draw do

  get 'new_dept/list'

  get 'new_dept/search'

  get 'new_dept/details'

  resources :distributor_missed_orders

  resources :distributor_missed_order_types

  resources :order_final_statuses

  resources :order_list_miles

  resources :vpp_deal_trans

  resources :distributor_stock_ledger_types

  get 'deal_tran/list'
  get 'deal_tran/search'
  get 'deal_tran/details'
  get 'transfer_order' => 'corporates#transfer_order'

  resources :distributor_stock_summaries

  resources :distributor_pincode_lists

  resources :distributor_stock_ledgers

  resources :distributor_stock_books

  resources :corporate_active_masters

  resources :help_files
  get 'help' => 'help_files#index'
  get 'search' => 'help_files#index'

  resources :page_names

  resources :page_trails

  resources :promotions

  resources :message_types
 
  resources :message_statuses
 
  resources :message_on_orders

  resources :product_cost_masters
   resources :product_cost_masters do
    collection { post :import }
  end

  resources :product_test_ppos

  resources :product_sample_stocks
  #get 'test_ppo' => 'product_ppo_news#index'
 
  mount Bootsy::Engine => '/bootsy', as: 'bootsy'
  get 'wholesale_distributors/list'
  get 'wholesale_distributors/search'
  get 'wholesale_distributors/details'
  get 'wholesale_returns/list'
  get 'wholesale_returns/search'
  get 'wholesale_returns/details'
  get 'wholesale_sales' => 'tempinv_newwlsdet/list'
  get 'branch_sales' => 'newwlsdet/list'

  resources :order_updates

  get 'sales_ppo_report/summary'
  get 'ppo_report' => 'sales_ppo_report#summary'
  get 'sales_ppo_report/daily'
  get 'daily_ppo' => 'sales_ppo_report#daily'
  get 'sales_ppo_report/hourly'
  get 'hourly_ppo' => 'sales_ppo_report#hourly'
  get 'sales_ppo_report/show'
  get 'show_ppo' => 'sales_ppo_report#show'
  get 'sales_ppo_report/channel'
  get 'channel_ppo' => 'sales_ppo_report#channel'
  get 'sales_ppo_report/hour_performance'
  get 'hour_performance' => 'sales_ppo_report#hour_performance'
  get 'sales_ppo_report/ppo_details'
  get 'ppo_details' => 'sales_ppo_report#ppo_details'
  get 'sales_ppo_report/orders'
  get 'ppo_products' => 'sales_ppo_report#ppo_products'

  resources :tax_rates

  get 'packing_cost/list'
  get 'packing_cost/search'
  get 'packing_cost/details'
  get 'listofproducts' => 'product_masters#listofproducts'
  get 'productwithcosts' => 'product_cost_masters#product_costs'
  get 'showprod' => 'product_masters#showprod'


 
  devise_for :logins
#sales report 
  get 'sales_reports' => 'sales_report#index' 
  get 'sales_report/index'
  get 'sales_report' => 'sales_report#summary' 
  get 'sales_report/summary'
  get 'sales_report/hourly'
  get 'hourly_report' => 'sales_report#hourly'
 
  get 'sales_report/daily'
  get 'daily_report' => 'sales_report#daily'
  get 'sales_report/channel'
  get 'channel_report' => 'sales_report#channel'
  get 'sales_report/channel_sales'
  get 'channel_sales' => 'sales_report#channel'
  get 'sales_report/employee'
  get 'employee_report' => 'sales_report#employee'
  get 'sales_report/city'
  get 'city_report' => 'sales_report#city'
  get 'sales_report/product'
  get 'product_report' => 'sales_report#product'
  get 'sales_report/show'
  get 'show_report' => 'sales_report#show'
  get 'sales_report/product_sold'
  get 'products_sold' => 'sales_report#product_sold'
  get 'sales_report/order_summary'
  get 'order_summary' => 'sales_report#order_summary'
  get 'sales_report/orders'
  get 'orders_list' => 'sales_report#orders'
  

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
  get 'detailedordersearch' => 'order_masters#detailed_search'
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
  get 'stockbook_details' => 'product_stock_books#stockbook_details'
 

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
  get 'show_city' => 'india_city_lists#show_city'
  get 'show_pincode' => 'india_pincode_lists#show_pincode'
    #step 3
  get 'upsell' => 'customerorder#upsell'
  post 'addupsell' => 'customerorder#add_upsell'
  get 'deleteupsell' => 'order_lines#deleteupsell'

  #step 3 added for appending the offer details
  get 'offers' => 'customerorder#show_offers'
  post 'addoffer' => 'customerorder#add_offer'

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
  
 # put 'groupdestroy' => 'campaign_playlists#groupdestroy' 
 # put 'campaign_playlists#groupdestroy'

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
  post 'insert_playlist' => 'campaign_playlists#campaign_playlist_insert'
  post 'create_playlist' => 'campaign_playlists#create_playlist_with_media_tape_head'
  #post 'update__playlist' => 'campaign_playlists#create_playlist_with_media_tape_head'
  post 'updatecampaigntimings' => 'campaign_playlists#updatecampaigntimings'
  post 'update_ppo_on_addition' => 'campaign_playlists#update_ppo_on_addition'

  #post 'neworder' => 'create_order#index'

  #get 'showcampaign' => 'campaigns#show'
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
  get 'dealer_enquiry' => 'interaction_masters#dealer_enquiry'
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
    post 'create_new_quick_playlist' => 'campaign_playlists#quick_create'
    
    get 'product_upsell/list'
    get 'product_upsell/search'
    get 'product_upsell/details'
    get 'product_upsell' => 'product_upsell#details'
    get 'productupsell' => 'product_upsell#list'

    get 'productreport' => 'product_report#list'
    get 'product_report/search'
    get 'productdetails' => 'product_report#details' 

    get 'showproductstock' => 'product_stocks#showfordate'
    put 'updateproductstock' => 'product_stocks#updatefordate'
     #stock report opening stock
    get 'openingstockreport' => 'product_report#opening_stock_report'
     #stock report purchases
    get 'purchasedstockreport' => 'product_report#purchased_stock_report'
     #stock report retail returns
    get 'retailreturnedreport' => 'product_report#retail_returned_stock_report'
    #stock report retail sold
    get 'retailsoldreport' => 'product_report#retail_sold_stock_report'
    #stock report wholesale returned
     get 'wholesalereturnreport' => 'product_report#wholesale_return_stock_report'
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
  get 'oldhelp'    => 'product#help'
  get 'oldabout'   => 'product#about'
  get 'oldcontact' => 'product#contact'
 
  get 'dealers' => 'address_dealer#list'
 
 # get 'help'    => 'project#help'
  get 'about'   => 'project#about'
  get 'contact' => 'project#contact'
  #get 'dropdown' => 'project#dropdown'
  #get "project/update_text", as: "update_text"
  get "productdetails" => 'product_masters#details'
  get "producttraining" => 'product_training_manuals#training'
  get "producttraining_text" => 'product_training_manuals#training_text'  
  get "productvariantdetails" => 'product_variants#details'
  get "productvariantcombined" => 'product_variants#combined'
  post "updatevariantmaster" => 'product_variants#update_variant_master_id'
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
