json.array!(@distributor_missed_order_types) do |distributor_missed_order_type|
  json.extract! distributor_missed_order_type, :id, :name, :sort_order, :description
  json.url distributor_missed_order_type_url(distributor_missed_order_type, format: :json)
end
