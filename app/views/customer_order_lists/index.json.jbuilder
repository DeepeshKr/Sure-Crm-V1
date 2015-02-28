json.array!(@customer_order_lists) do |customer_order_list|
  json.extract! customer_order_list, :id
  json.url customer_order_list_url(customer_order_list, format: :json)
end
