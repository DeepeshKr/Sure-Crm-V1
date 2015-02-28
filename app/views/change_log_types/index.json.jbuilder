json.array!(@change_log_types) do |change_log_type|
  json.extract! change_log_type, :id, :name, :description
  json.url change_log_type_url(change_log_type, format: :json)
end
