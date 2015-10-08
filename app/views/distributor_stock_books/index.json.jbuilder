json.array!(@distributor_stock_books) do |distributor_stock_book|
  json.extract! distributor_stock_book, :id, :corporate_id, :product_master_id, :product_variant_id, :product_list_id, :prod, :opening_qty, :opening_value, :10,2, :sold_qty, :sold_value, :10,2, :return_qty, :return_value, :10,2, :closing_qty, :closing_value, :10,2, :book_date, :list_barcode
  json.url distributor_stock_book_url(distributor_stock_book, format: :json)
end
