json.array!(@product_masters) do |product_master|
  json.extract! product_master, :id, :name, :categoryid, :inventoryid, :barcode, :price, :taxes, :total, :extproductcode, :description
  json.url product_master_url(product_master, format: :json)
end
