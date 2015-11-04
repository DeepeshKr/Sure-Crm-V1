json.array!(@order_final_statuses) do |order_final_status|
  json.extract! order_final_status, :id, :name, :sort_order, :description
  json.url order_final_status_url(order_final_status, format: :json)
end
