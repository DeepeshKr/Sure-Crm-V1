json.array!(@order_fors) do |order_for|
  json.extract! order_for, :id, :name, :description
  json.url order_for_url(order_for, format: :json)
end
