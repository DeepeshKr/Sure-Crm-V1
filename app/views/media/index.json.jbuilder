json.array!(@media) do |medium|
  json.extract! medium, :id, :name, :telephone, :alttelephone, :state, :active, :corporateid, :description
  json.url medium_url(medium, format: :json)
end
