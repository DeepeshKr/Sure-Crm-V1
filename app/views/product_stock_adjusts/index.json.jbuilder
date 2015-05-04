json.array!(@product_stock_adjusts) do |product_stock_adjust|
  json.extract! product_stock_adjust, :id, :product_master_id, :product_list_id, :change_stock, :ext_prod_code, :barcode, :created_date, :emp_code, :emp_id, :name, :description
  json.url product_stock_adjust_url(product_stock_adjust, format: :json)
end
