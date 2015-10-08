json.array!(@distributor_stock_summaries) do |distributor_stock_summary|
  json.extract! distributor_stock_summary, :id, :corporate_id, :product_master_id, :product_variant_id, :product_list_id, :prod, :stock_balance, :rupee_balance, :stock_returned, :summary_date
  json.url distributor_stock_summary_url(distributor_stock_summary, format: :json)
end
