json.array!(@sales_ppo_email_alerts) do |sales_ppo_email_alert|
  json.extract! sales_ppo_email_alert, :id, :email_id, :last_delivered_on
  json.url sales_ppo_email_alert_url(sales_ppo_email_alert, format: :json)
end
