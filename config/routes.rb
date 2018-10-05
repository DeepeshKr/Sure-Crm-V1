Rails.application.routes.draw do
  
  resources :sales_report_pay_u_steps
  devise_for :logins
  #root             'product#home'
  root 'project#home'
  get 'oldhelp'    => 'project#help'
  get 'log'    => 'project#help'
  get 'oldabout'   => 'product#about'
  get 'oldcontact' => 'product#contact'
   get 'project/longtable'

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
  # addonproducts
  # get "creditcard" => 'project#luhn'

  get 'signup'  => 'users#new'
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'
  
  get 'employee_incentives/index'
  get 'employee_incentives/search'
  get 'employee_incentives/details'

  
  
  get 'disposition_report_sales_report_team' => 'sales_report_team#disposition_report'
  get 'sales_report_team/disposition_report'
  get 'showproducts_sales_report_team' => 'sales_report_team#showproducts'
  get 'sales_report_team/showproducts'

 # require 'resque/server'
  require 'resque/server'
  require "resque_web"
  # Of course, you need to substitute your application name here, a block
  # like this probably already exists.

  mount Resque::Server.new, at: "/resque"
  mount ResqueWeb::Engine => "/resque_web"
  mount Delayed::Web::Engine, at: '/jobs'
  
  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]

  get "select_two" => 'return_rates#demo'
  get 'cashsale/index'
  get 'cashsale/search'
  get 'cashsale/details'

  get 'states/edit_all'
  post 'states_update_all' => 'states#update_all'
  post 'states/update_all'

  get "cinergy_xml" => "campaign_playlists#cinergy_xml"
  get "recent_missed_orders" => 'distributor_missed_orders#recent'
  post "media_switch_cdm" => "media#switch_cdm"
  post "media/switch_cdm"
  get "hbn_channels" => "media#all_hbn"
  post "send_demo_message" => 'message_on_orders#send_demo_message'

  get 'new_dept/list'
  get 'new_dept/search'
  get 'new_dept/details'
  
  get 'deal_tran/list'
  get 'deal_tran/search'
  get 'deal_tran/details'
  get 'transfer_order' => 'corporates#transfer_order'
  get 'transfer_order_pricing' => 'corporates#transfer_order_pricing'

  post 'distributor_upload_orders/switch_on'
  post 'distributor_upload_orders/switch_off'
  
  post "distributor_quick_add_pincode" => 'distributor_pincode_lists#quick_add_pincode'
  post "distributor_quick_add_state_pincode" => "distributor_pincode_lists#quick_add_state_pincode"
  
  get 'help' => 'help_files#index'
  get 'search' => 'help_files#index'
  
  get 'message_on_orders/payumoney'
  get 'message_on_orders_payumoney' => 'message_on_orders#payumoney'
  
  get "fedex_bill_download" => "fedex_bill_checks#download"
  delete "fedex_bill_delete" => "fedex_bill_checks#delete"
  delete "remove_all_missed_orders" => "distributor_missed_orders#remove_missed"
  delete "remove_all_corporate_missed_orders" => "distributor_missed_orders#remove_missed"
  delete "remove_all_corporate_specific_missed_orders" => "distributor_missed_orders#remove_missed"
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

  get 'media_cost_masters/get_costs'
  get 'media_cost_masters_get_costs' => 'media_cost_masters#get_costs'
  
  get 'media_cost_masters/hbn_cost_summary'
  get 'media_cost_masters_hbn_cost_summary' => 'media_cost_masters#hbn_cost_summary'
  #new sales ppo
  post 'sales_ppos/re_create_ppo'
  post 'sales_ppos/recreate_ppo_for_order_id'
  post 'sales_ppos/recreate_ppo_between_days'
  
  put 'sales_ppos/re_calculate_order_id'
  put 're_calculate_order_id_sales_ppos' => 'sales_ppos#re_calculate_order_id'
  
  get 'sales_ppos/index'
  get 'sales_ppos' => 'sales_ppos#index'

  get 'sales_ppos/show_wise'
  get 'sales_ppos_show_wise' => 'sales_ppos#show_wise'

  get 'sales_ppos/half_hourly'
  get 'sales_ppos_half_hourly' => 'sales_ppos#half_hourly'
  get 'sales_ppos/half_hour_sales'
  get 'sales_ppos_half_hour_sales' => 'sales_ppos#half_hour_sales'
  get 'sales_ppos/half_hour_performance'
  get 'sales_ppos_half_hour_performance' => 'sales_ppos#half_hour_performance'

  get 'sales_ppos/operator_sales_performance'
  get 'sales_ppos_operator_sales_performance' => 'sales_ppos#operator_sales_performance'
  
  get 'sales_ppos/product_performance'
  get 'sales_ppos_product_performance' => 'sales_ppos#product_performance'
  
  get 'sales_ppos/simulate_product_performance'
  get 'sales_ppos_simulate_product_performance' => 'sales_ppos#simulate_product_performance'

  get 'sales_ppos/product_long_term_performance'
  get 'sales_ppos_product_long_term_performance' => 'sales_ppos#product_long_term_performance'
  
  get 'sales_ppos/show_performance'
  get 'sales_ppos_show_performance' => 'sales_ppos#show_performance'

  get 'sales_ppos/details'
  get 'sales_ppos_details' => 'sales_ppos#details'

  get 'sales_ppos/show_all'
  get 'sales_ppos_show_all' => 'sales_ppos#show_all'
  get 'sales_ppos/demo'
  get 'sales_ppos_details' => 'sales_ppos#demo'

  #old sales ppo
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

  get 'sales_ppo_report/product_performance'
  get 'product_performance' => 'sales_ppo_report#product_performance'
  get 'sales_ppo_report/show_performance'
  get 'show_performance' => 'sales_ppo_report#show_performance'
  get 'sales_ppo_report/product_hour_performance'
  get 'product_hour_performance' => 'sales_ppo_report#product_hour_performance'

  get 'sales_ppo_report/hour_performance'
  get 'hour_performance' => 'sales_ppo_report#hour_performance'

  get 'sales_ppo_report/hour_sales_performance'
  get 'hour_sales_performance' => 'sales_ppo_report#hour_sales_performance'

  get 'sales_ppo_report/operator_performance'
  get 'operator_performance' => 'sales_ppo_report#operator_performance'
  get 'sales_ppo_report/ppo_details'
  get 'ppo_details' => 'sales_ppo_report#ppo_details'
  get 'sales_ppo_report/orders'
  get 'ppo_products' => 'sales_ppo_report#ppo_products'

  get 'packing_cost/list'
  get 'packing_cost/search'
  get 'packing_cost/details'
  get 'listofproducts' => 'product_masters#listofproducts'
  get 'showprod' => 'product_masters#showprod'
  #get 'productcost' => 'product_cost#details'
  get 'productcost' => 'product_cost_masters#product_costs'
  get 'productwithcosts' => 'product_cost_masters#product_costs'
  #update_all_product_costs
  get 'product_costs_not_found' => 'product_cost_masters#product_costs_not_found'
  
  # get sales report team
  get 'sales_reports_team' => 'sales_report_team#index'
  get 'sales_report_team/show_wise'
  get 'sales_report_team_show_wise' => 'sales_report_team#show_wise'
  get 'sales_report_team/agent_order'
  get 'sales_report_team_agent_order_list' => 'sales_report_team#agent_order_list'
  get 'sales_report_team/agent_order_list'
  get 'pay_u_orders_sales_report_team' => 'sales_report_team#pay_u_orders'
  get 'sales_report_team/products_sold'
  get 'products_sold_sales_report_team' => 'sales_report_team#products_sold'
  get 'sales_report_team/pay_u_orders'
  get 'agent_common_upsell_order_sales_report_team' => 'sales_report_team#agent_common_upsell_order'
  get 'sales_report_team/agent_common_upsell_order'
  get 'agent_basic_upsell_order_sales_report_team' => 'sales_report_team#agent_basic_upsell_order'
  get 'sales_report_team/agent_basic_upsell_order'
  get 'sales_report_team_not_completed' => 'sales_report_team#not_completed'
  get 'sales_report_team/not_completed'
  
  get 'sales_report_team_search_custdetails' => 'sales_report_team#search_custdetails'
  get 'sales_report_team/search_custdetails'
  
  get 'sales_report_team_employee_upsales_report' => 'sales_report_team#employee_upsales_report'
  get 'sales_report_team/employee_upsales_report'
  
  
  #sales report
  get 'sales_reports' => 'sales_report#index'
  get 'sales_report/index'
  get 'not_completed' => 'sales_report#not_completed'
  get 'sales_report/not_completed'
  get 'sales_report' => 'sales_report#summary'
  get 'sales_report/summary'
  get 'hourly_report' => 'sales_report#hourly'
  get 'sales_report/hourly'
  get 'open_orders' => 'sales_report#open_orders'
  get 'sales_report/open_orders'
  get 'pincode_orders' => 'sales_report#pincode_orders'
  get 'sales_report/pincode_orders'
  get 'daily_report' => 'sales_report#daily'
  get 'sales_report/daily'
  
  get 'sales_report_channel_group_product_sold' => "sales_report#channel_group_product_sold"
  get 'sales_report/channel_group_product_sold'
  
  get 'sales_report_channel_group_sales_summary' => "sales_report#channel_group_sales_summary"
  get 'sales_report/channel_group_sales_summary'
  
  get 'pay_u_orders_sales_report' => 'sales_report#pay_u_orders'
  get 'sales_report/pay_u_orders'
  
  get 'employee_pay_u_report_sales_report' => 'sales_report#employee_pay_u_report'
  get 'sales_report/employee_pay_u_report'
  
  get 'channel_report' => 'sales_report#channel'
  get 'sales_report/channel'
  
  get 'channel_summary_report' => 'sales_report#channel_summary_report'
  get 'sales_report/channel_summary_report'
  
  get 'channel_sales_summary' => 'sales_report#channel_sales_summary'
  get 'sales_report/channel_sales_summary'
  
  get 'channel_sales' => 'sales_report#channel_sales'
  get 'sales_report/channel_sales'
  
  get 'sales_report_channel_product_sales_report' => 'sales_report#channel_product_sales_report'
  get 'sales_report/channel_product_sales_report'
  
  get 'sales_report_channel_city_sales_report' => 'sales_report#channel_city_sales_report'
  get 'sales_report/channel_city_sales_report'
  
  
  # final report
  get 'cdm_report' => 'sales_report#cdm_report'
  get 'sales_report/cdm_report'
  
  get 'sales_report_gender_report' => 'sales_report#gender_report'
  get 'sales_report/gender_report'
 
  get 'sales_report_birthday_list' => 'sales_report#birthday_list'
  get 'sales_report/birthday_list'
  
  # source 1 (order sales)
  get 'cdm_sales_summary' => 'sales_report#cdm_sales_summary'
  get 'sales_report/cdm_sales_summary'
  # source 2 (media pre paid info)
  get 'cdm_operator_list_summary' => 'sales_report#cdm_operator_list_summary'
  get 'sales_report/cdm_operator_list_summary'

  get 'channel_consolidated_daily_report' => 'sales_report#channel_consolidated_daily_report'
  get 'sales_report/channel_consolidated_daily_report'

  get 'sales_report_sales_incentives' => 'sales_report#sales_incentives'
  get 'sales_report/sales_incentives'
  
  get 'disposition_report' => 'sales_report#disposition_report'
  get 'sales_report/disposition_report'
  
  get 'hourly_products' => 'sales_report#hourly_products'
  get 'sales_report/hourly_products'
  
  get 'hour_sales' => 'sales_report#hour_sales'
  get 'sales_report/hour_sales'
  
  get 'employee_report' => 'sales_report#employee'
  get 'sales_report/employee'
  
  get 'city_report' => 'sales_report#city'
  get 'sales_report/city'
  
  get 'product_report' => 'sales_report#product'
  get 'sales_report/product'
  
  get 'show_report' => 'sales_report#show'
  get 'sales_report/show'
  
  get 'products_sold' => 'sales_report#product_sold'
  get 'sales_report/product_sold'
  
  get 'fitness_products_sold' => 'sales_report#fitness_products_sold'
  get 'sales_report/fitness_products_sold'
  
  get 'order_summary' => 'sales_report#order_summary'
  get 'sales_report/order_summary'
  
  get 'orders_list' => 'sales_report#orders'
  get 'sales_report/orders'
  

  get 'tempinv_newwlsdet/list'
  get 'tempinv_newwlsdet/search'
  get 'tempinv_newwlsdet/details'
  get 'custdetailsreport' => 'custdetails#list'
  get 'custdetails/list'
  get 'custdetails/search'
  # get 'custordersearch' => 'custdetails#search'
  get 'custordersearch' => 'order_masters#search'
  get 'detailedordersearch' => 'order_masters#detailed_search'
  get 'order_masters_online_search' => 'order_masters#online_search'
  get 'order_masters/online_search'
  get 'order_masters_online_one_day_search' => 'order_masters#online_one_day_search'
  get 'order_masters/online_one_day_search'
  
  get 'order_masters_online_pending_search' => 'order_masters#online_pending_search'
  get 'order_masters/online_pending_search'
  
  post 'order_masters_online_add_to_order' => 'order_masters#online_add_to_order'
  post 'order_masters/online_add_to_order'
  
  get 'order_masters_review' => 'order_masters#review'
  get 'order_masters/review'
  
  get 'custdetails/details'
  get 'custdetails/product_details'
  get 'custdetails/between_date'
  
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

  get 'stockbook' => 'product_stock_books#summary'
  get 'product_stock_books/summary'
  get 'stockbook_details' => 'product_stock_books#stockbook_details'
  # sales team
  get 'employees/sales_team'
  get 'sales_team' => 'employees#sales_team'
  # campaign playlist search

  # pay u money details search
  post 'payumoney_details/process_order'
  post 'payumoney_details/regenerate_sms_for_order'
  
  get 'payumoney_details/index'
  get 'payumoney_details' => 'payumoney_details#index'
  get 'payumoney_details/search'
  get 'payumoney_details_search' => 'payumoney_details#search'
  get 'payumoney_details/open_orders'
  get 'payumoney_details_open_orders' => 'payumoney_details#open_orders'
  get 'payumoney_details/details'
  get 'payumoney_details_detail' => 'payumoney_details#details'
  
  get 'india_pincode_lists/check_for_updates' 
  get 'india_pincode_lists_check_for_updates' => 'india_pincode_lists#check_for_updates'
  post 'india_pincode_lists/update_pincode_list'
  post 'india_pincode_lists_update_pincode_list' => 'india_pincode_lists#details'
  
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
  post 'customer_order_lists/inoracle'
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
  get 'update_tapes_preset' => 'media_tape_heads#update_tapes_preset'
  get 'update_tapes_auto' => 'media_tape_heads#update_tapes_auto'
  get 'update_tapes_manual' => 'media_tape_heads#update_tapes_manual'
  get 'tape_list_preset' => 'media_tape_heads#tape_list_preset'
  get 'tape_list_auto' => 'media_tape_heads#tape_list_auto'
  get 'tape_list_manual' => 'media_tape_heads#tape_list_manual'
  get 'campaign_playlists/search'
  get 'campaign_playlists_search' => 'campaign_playlists#search'
  get 'campaign_playlists/new_media_cost'
  get 'campaign_playlists_new_media_cost' => 'campaign_playlists#new_media_cost'
  post 'campaign_playlists/update_media_cost'
  post 'campaign_playlists_update_media_cost' => 'campaign_playlists#update_media_cost'

  #post 'campaign_playlists/create_playlist_with_media_tape_head'
  post 'insert_playlist' => 'campaign_playlists#campaign_playlist_insert'
  post 'campaign_playlists/create_playlist_with_media_tape_head'
  post 'create_playlist' => 'campaign_playlists#create_playlist_with_media_tape_head'
  #post 'update__playlist' => 'campaign_playlists#create_playlist_with_media_tape_head'
  post 'updatecampaigntimings' => 'campaign_playlists#updatecampaigntimings'
  post 'update_ppo_on_addition' => 'campaign_playlists#update_ppo_on_addition'

  #post 'neworder' => 'create_order#index'
  #get 'showcampaign' => 'campaigns#show'
  #get 'recentorders' => 'create_order#show_recentorders'

  get 'create' => 'customers#createnew'
  post   'add' => 'customers#add'
  get 'call_centre_dealers' => 'corporates#call_centre_dealers'
  get 'corporates/call_centre_dealers'
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
  
  # post 'pending_order_generate_orders' => 'pending_order#generate_orders'
 #  post 'pending_orders/generate_orders'
 #  post 'pending_orders/generate_order_for_order_id'
 #  post 'pending_orders/generate_order_for_order_no'
  # get 'corporate_type' => 'corporates#list_type'
  resources :help_files do
    collection { post :import }
  end
  
  resources :campaigns do
    collection { post :import_pvt_playlist, :delete_pvt_playlist }
    collection { get :index, :new_private_campaign, :private_campaign_playlist, :private_campaign_playlists }
  end
  
  resources :marketing_messages
  resources :sales_upsale_products
  
  resources :dispatch_call_statuses
  resources :order_dispatch_statuses
  resources :pending_orders do
      collection { get :multi_edit }
      collection { post :import, :generate_orders, :generate_order_for_order_id, :generate_order_for_order_no, :edit_multiple}
      
      collection {put :update_multiple}
  end
 # , :collection => {  => :post,  => :put }
  resources :page_names
  resources :page_trails
  resources :promotions
  resources :message_types
  resources :message_statuses
  resources :message_on_orders
  
  resources :registration_statuses
  resources :fat_to_fit_email_statuses
  #resources :sales_ppos
  resources :campaign_missed_lists
  resources :pincode_service_levels
  resources :courier_lists
  
  resources :product_cost_masters
  resources :product_cost_masters do
    collection { post :import, :update_all_product_costs, :update_product_cost }
  end
  
  resources :fedex_bill_checks
  resources :fedex_bill_checks do
     collection { post :import }
  end
  
  resources :product_test_ppos
  resources :product_sample_stocks
  resources :order_updates
  resources :tax_rates
  
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
  
  resources :product_variants do
    collection { get :get_csv }
  end
  
  resources :media_tape_heads
  resources :india_city_lists
  resources :cust_details_track_logs
  resources :cust_details_tracks
  resources :sales_ppo_product_alerts
  resources :sales_ppo_email_alerts
  resources :product_master_images
  resources :payumoney_statuses
  resources :app_comment_display_levels
  resources :app_comment_types
  resources :app_feature_comments
  resources :app_priorities
  resources :app_statuses
  resources :app_velocities
  resources :app_user_satisfaction_levels
  resources :app_feature_types
  resources :app_lists
  resources :app_feature_requests
  resources :campaign_playlist_to_products
  resources :sales_ppo_defaults
  resources :return_rates
  resources :list_of_servers
  resources :daily_task_logs
  resources :daily_tasks
  resources :cable_opertor_comms
  resources :order_final_statuses
  resources :order_list_miles
  resources :vpp_deal_trans
  
  resources :distributor_missed_orders
  resources :distributor_missed_order_types
  resources :distributor_stock_summaries
  resources :distributor_upload_orders
  resources :distributor_product_lists
  resources :distributor_missed_pincodes
  resources :distributor_stock_ledger_types
  resources :distributor_stock_ledgers
  resources :distributor_stock_books
  resources :distributor_pincode_lists
  resources :corporate_active_masters
  
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

  mount Upmin::Engine => '/admin'

  
  resources :sales_incentives
  resources :user_roles
  resources :customer_order_lists
  resources :corporate_types, :media_commisions, :product_sell_types, :product_variant_add_ons
  resources :order_fors, :media_groups,  :create_order , :order_payments
  resources :media_groups, :media_commisions, :customer_credit_cards, :change_log_trails, :change_log_types
  resources :order_masters, :order_lines, :orderpaymentmodes, :interaction_transcripts, :interaction_masters
  resources :product_training_manuals, :product_masters
  resources :media, :bills, :order_sources, :customers
  resources :customer_addresses, :address_valids, :address_types, :interaction_categories
  resources :campaign_stages, :product_types, :product_categories, :interaction_priorities
  resources :corporates, :product_warehouses, :interaction_statuses, :interaction_users
  resources :employees, :users, :sessions, :product_active_codes, :states
  resources :salutes, :employment_types, :employee_roles, :order_line_dispatch_statuses
  resources :order_status_masters, :product_training_headings, :product_inventory_codes
  #resources :campaign_playlists, :collection => { :edit_individual => :post, :update_individual => :put }
  resources :campaign_playlists

end