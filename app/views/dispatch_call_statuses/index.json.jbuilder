json.array!(@dispatch_call_statuses) do |dispatch_call_status|
  json.extract! dispatch_call_status, :id, :name, :description, :sort_order
  json.url dispatch_call_status_url(dispatch_call_status, format: :json)
end
