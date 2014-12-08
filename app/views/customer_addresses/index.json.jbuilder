json.array!(@customer_addresses) do |customer_address|
  json.extract! customer_address, :id, :customer_id, :name, :address1, :address2, :address3, :landmark, :city, :pincode, :state, :district, :country, :telephone1, :telephone2, :fax, :description, :valid_id
  json.url customer_address_url(customer_address, format: :json)
end
