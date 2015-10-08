json.array!(@distributor_stock_ledgers) do |distributor_stock_ledger|
  json.extract! distributor_stock_ledger, :id, :corporate_id, :product_master_id, :product_variant_id, :product_list_id, :prod, :name, :description, :stock_change, :ledger_date
  json.url distributor_stock_ledger_url(distributor_stock_ledger, format: :json)
end
