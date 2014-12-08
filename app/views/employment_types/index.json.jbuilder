json.array!(@employment_types) do |employment_type|
  json.extract! employment_type, :id, :name, :sortorder
  json.url employment_type_url(employment_type, format: :json)
end
