json.array!(@media_groups) do |media_group|
  json.extract! media_group, :id, :name, :description
  json.url media_group_url(media_group, format: :json)
end
