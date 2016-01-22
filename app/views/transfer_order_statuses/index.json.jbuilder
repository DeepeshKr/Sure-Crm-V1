json.array!(@transfer_order_statuses) do |transfer_order_status|
  json.extract! transfer_order_status, :id, :name, :sort_order, :description
  json.url transfer_order_status_url(transfer_order_status, format: :json)
end
