json.array!(@product_cost_masters) do |product_cost_master|
  json.extract! product_cost_master, :id, :product_id, :product_list_id, :prod, :barcode, :product_cost, :basic_cost, :shipping_handling, :postage, :tel_cost, :transf_order_basic, :dealer_network_basic, :wholesale_variable_cost, :royalty, :cost_of_return, :call_centre_commission
  json.url product_cost_master_url(product_cost_master, format: :json)
end
