json.array!(@product_test_ppos) do |product_test_ppo|
  json.extract! product_test_ppo, :id, :name, :prod_code, :barcode, :basic_price, :shipping, :channel, :aired_date, :slot, :orders, :ppo, :ad_cost, :description
  json.url product_test_ppo_url(product_test_ppo, format: :json)
end
