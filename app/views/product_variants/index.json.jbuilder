json.array!(@product_variants) do |product_variant|
  json.extract! product_variant, :id, :name, :productmasterid, :variantbarcode, :price, :taxes, :total, :extproductcode, :description, :activeid
  json.url product_variant_url(product_variant, format: :json)
end
