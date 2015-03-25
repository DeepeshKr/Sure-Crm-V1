json.array!(@product_master_add_ons) do |product_master_add_on|
  json.extract! product_master_add_on, :id, :product_master_id, :product_list_id, :activeid, :change_price
  json.url product_master_add_on_url(product_master_add_on, format: :json)
end
