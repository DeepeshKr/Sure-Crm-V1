json.array!(@sales_ppo_product_alerts) do |sales_ppo_product_alert|
  json.extract! sales_ppo_product_alert, :id, :product_list_id
  json.url sales_ppo_product_alert_url(sales_ppo_product_alert, format: :json)
end
