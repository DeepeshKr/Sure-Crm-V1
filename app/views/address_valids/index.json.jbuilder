json.array!(@address_valids) do |address_valid|
  json.extract! address_valid, :id, :name
  json.url address_valid_url(address_valid, format: :json)
end
