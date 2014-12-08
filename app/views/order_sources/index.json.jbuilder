json.array!(@order_sources) do |order_source|
  json.extract! order_source, :id, :name
  json.url order_source_url(order_source, format: :json)
end
