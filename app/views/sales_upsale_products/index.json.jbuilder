json.array!(@sales_upsale_products) do |sales_upsale_product|
  json.extract! sales_upsale_product, :id, :product_list_id
  json.url sales_upsale_product_url(sales_upsale_product, format: :json)
end
