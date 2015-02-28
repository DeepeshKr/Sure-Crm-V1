json.array!(@product_sell_types) do |product_sell_type|
  json.extract! product_sell_type, :id, :name, :description
  json.url product_sell_type_url(product_sell_type, format: :json)
end
