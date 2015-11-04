json.array!(@order_list_miles) do |order_list_mile|
  json.extract! order_list_mile, :id, :name, :sort_order, :description
  json.url order_list_mile_url(order_list_mile, format: :json)
end
