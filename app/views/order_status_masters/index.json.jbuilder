json.array!(@order_status_masters) do |order_status_master|
  json.extract! order_status_master, :id, :name, :sortorder
  json.url order_status_master_url(order_status_master, format: :json)
end
