json.array!(@distributor_product_lists) do |distributor_product_list|
  json.extract! distributor_product_list, :id, :product_list_id, :name, :sort_order
  json.url distributor_product_list_url(distributor_product_list, format: :json)
end
