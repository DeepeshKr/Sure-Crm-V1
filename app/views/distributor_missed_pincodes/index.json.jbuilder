json.array!(@distributor_missed_pincodes) do |distributor_missed_pincode|
  json.extract! distributor_missed_pincode, :id, :pincode, :no_of_orders, :total_value, :last_ran_on, :description
  json.url distributor_missed_pincode_url(distributor_missed_pincode, format: :json)
end
