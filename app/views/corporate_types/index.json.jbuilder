json.array!(@corporate_types) do |corporate_type|
  json.extract! corporate_type, :id, :name, :description
  json.url corporate_type_url(corporate_type, format: :json)
end
