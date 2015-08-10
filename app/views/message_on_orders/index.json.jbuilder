json.array!(@message_on_orders) do |message_on_order|
  json.extract! message_on_order, :id, :customer_id, :message_type_id, :message_status_id, :message, :response, :mobile_no, :alt_mobile_no
  json.url message_on_order_url(message_on_order, format: :json)
end
