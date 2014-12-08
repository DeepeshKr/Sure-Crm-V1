json.array!(@customers) do |customer|
  json.extract! customer, :id, :salute, :first_name, :last_name, :mobile, :alt_mobile, :emailid, :alt_emailid, :description
  json.url customer_url(customer, format: :json)
end
