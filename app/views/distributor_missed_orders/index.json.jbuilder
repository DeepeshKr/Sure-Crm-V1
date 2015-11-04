json.array!(@distributor_missed_orders) do |distributor_missed_order|
  json.extract! distributor_missed_order, :id, :corporate_id, :missed_type_id, :order_value, :order_no, :order_id, :description
  json.url distributor_missed_order_url(distributor_missed_order, format: :json)
end
