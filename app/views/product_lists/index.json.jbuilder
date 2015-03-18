json.array!(@product_lists) do |product_list|
  json.extract! product_list, :id, :product_variant_id, :product_spec_list_id, :extproductcode, :list_barcode
  json.url product_list_url(product_list, format: :json)
end
