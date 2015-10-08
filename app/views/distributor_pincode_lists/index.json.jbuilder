json.array!(@distributor_pincode_lists) do |distributor_pincode_list|
  json.extract! distributor_pincode_list, :id, :name, :sort_order, :pincode
  json.url distributor_pincode_list_url(distributor_pincode_list, format: :json)
end
