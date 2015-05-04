json.array!(@india_city_lists) do |india_city_list|
  json.extract! india_city_list, :id, :name, :state
  json.url india_city_list_url(india_city_list, format: :json)
end
