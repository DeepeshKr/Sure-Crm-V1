json.array!(@product_warehouses) do |product_warehouse|
  json.extract! product_warehouse, :id, :location_name, :address1, :address2, :address3, :landmark, :city, :pincode, :state, :country, :telephone1, :telephone2, :fax, :emailid, :description
  json.url product_warehouse_url(product_warehouse, format: :json)
end
