json.array!(@order_line_dispatch_statuses) do |order_line_dispatch_status|
  json.extract! order_line_dispatch_status, :id, :name, :sortorder
  json.url order_line_dispatch_status_url(order_line_dispatch_status, format: :json)
end
