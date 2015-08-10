json.array!(@message_statuses) do |message_status|
  json.extract! message_status, :id, :name, :description, :sort_order
  json.url message_status_url(message_status, format: :json)
end
