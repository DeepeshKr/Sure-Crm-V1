json.array!(@order_updates) do |order_update|
  json.extract! order_update, :id, :order_id, :orderno, :order_date, :process_date, :shipped_date, :return_date, :cancel_date, :paid_date
  json.url order_update_url(order_update, format: :json)
end
