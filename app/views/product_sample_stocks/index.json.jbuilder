json.array!(@product_sample_stocks) do |product_sample_stock|
  json.extract! product_sample_stock, :id, :product_master_id, :product_list_id, :product_name, :prod_code, :barcode, :basic_price, :shipping, :air_date, :orders, :stock, :description
  json.url product_sample_stock_url(product_sample_stock, format: :json)
end
