json.array!(@product_variant_add_ons) do |product_variant_add_on|
  json.extract! product_variant_add_on, :id, :productid, :productvariantid
  json.url product_variant_add_on_url(product_variant_add_on, format: :json)
end
