json.array!(@pincode_service_levels) do |pincode_service_level|
  json.extract! pincode_service_level, :id, :pincode, :total_orders, :total_value, :last_ran_on, :description, :courier_id, :time_to_deliver, :cod_avail, :distributor_avail, :paid_order, :paid_value
  json.url pincode_service_level_url(pincode_service_level, format: :json)
end
