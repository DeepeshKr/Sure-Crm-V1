json.array!(@sales_incentives) do |sales_incentive|
  json.extract! sales_incentive, :id, :name, :min_value, :max_value, :commission, :no_of, :description
  json.url sales_incentive_url(sales_incentive, format: :json)
end
