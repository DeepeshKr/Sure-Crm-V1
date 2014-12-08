json.array!(@salutes) do |salute|
  json.extract! salute, :id, :name
  json.url salute_url(salute, format: :json)
end
