json.array!(@corporates) do |corporate|
  json.extract! corporate, :id, :name, :address1, :address2, :address3, :landmark, :city, :pincode, :state, :district, :country, :telephone1, :telephone2, :fax, :website, :salute1, :first_name1, :last_name1, :designation1, :mobile1, :emaild1, :salute2, :first_name2, :last_name2, :designation2, :mobile2, :emailid2, :salute3, :first_name3, :last_name3, :designation3, :mobile3, :emailid3, :description
  json.url corporate_url(corporate, format: :json)
end
