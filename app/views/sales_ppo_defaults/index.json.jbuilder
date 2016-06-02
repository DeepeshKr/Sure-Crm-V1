json.array!(@sales_ppo_defaults) do |sales_ppo_default|
  json.extract! sales_ppo_default, :id, :name, :value, :description
  json.url sales_ppo_default_url(sales_ppo_default, format: :json)
end
