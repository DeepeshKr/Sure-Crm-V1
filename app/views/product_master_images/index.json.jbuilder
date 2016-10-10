json.array!(@product_master_images) do |product_master_image|
  json.extract! product_master_image, :id, :name, :description, :sort_order, :prod, :barcode, :product_variant_id, :product_list_id, :product_master_id
  json.url product_master_image_url(product_master_image, format: :json)
end
