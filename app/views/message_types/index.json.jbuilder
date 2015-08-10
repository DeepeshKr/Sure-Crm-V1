json.array!(@message_types) do |message_type|
  json.extract! message_type, :id, :name, :description, :sort_order
  json.url message_type_url(message_type, format: :json)
end
