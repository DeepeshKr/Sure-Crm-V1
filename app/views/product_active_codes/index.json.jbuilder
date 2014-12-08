json.array!(@product_active_codes) do |product_active_code|
  json.extract! product_active_code, :id, :name, :sortorder
  json.url product_active_code_url(product_active_code, format: :json)
end
