json.array!(@product_inventory_codes) do |product_inventory_code|
  json.extract! product_inventory_code, :id, :name, :sortorder
  json.url product_inventory_code_url(product_inventory_code, format: :json)
end
