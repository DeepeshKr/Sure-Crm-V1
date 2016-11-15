json.array!(@order_dispatch_statuses) do |order_dispatch_status|
  json.extract! order_dispatch_status, :id, :name, :description, :sort_order
  json.url order_dispatch_status_url(order_dispatch_status, format: :json)
end
