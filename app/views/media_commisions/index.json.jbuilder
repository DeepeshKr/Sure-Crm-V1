json.array!(@media_commisions) do |media_commision|
  json.extract! media_commision, :id, :name, :description
  json.url media_commision_url(media_commision, format: :json)
end
