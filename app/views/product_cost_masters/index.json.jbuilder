json.array!(@product_cost_masters) do |product_cost_master|
  json.extract! product_cost_master, :id, :product_id, :prod, :barcode, :cost, :revenue
  json.url product_cost_master_url(product_cost_master, format: :json)
end
