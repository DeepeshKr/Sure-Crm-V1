json.array!(@courier_lists) do |courier_list|
  json.extract! courier_list, :id, :name, :description, :contact_details, :tracking_url, :helpline, :sort_order, :ref_code, :active
  json.url courier_list_url(courier_list, format: :json)
end
