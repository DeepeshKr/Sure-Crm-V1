json.array!(@product_stocks) do |product_stock|
  json.extract! product_stock, :id, :product_master_id, :product_list_id, :current_stock, :ext_prod_code, :barcode, :checked_date, :emp_code, :emp_id
  json.url product_stock_url(product_stock, format: :json)
end
