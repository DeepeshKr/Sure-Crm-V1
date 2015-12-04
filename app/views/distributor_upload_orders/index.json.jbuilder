json.array!(@distributor_upload_orders) do |distributor_upload_order|
  json.extract! distributor_upload_order, :id, :order_id, :ext_order_id, :last_ran_on, :description, :online_order_id, :online_last_ran_on, :online_description
  json.url distributor_upload_order_url(distributor_upload_order, format: :json)
end
