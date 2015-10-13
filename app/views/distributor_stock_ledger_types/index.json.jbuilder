json.array!(@distributor_stock_ledger_types) do |distributor_stock_ledger_type|
  json.extract! distributor_stock_ledger_type, :id, :name, :sort_order, :description
  json.url distributor_stock_ledger_type_url(distributor_stock_ledger_type, format: :json)
end
