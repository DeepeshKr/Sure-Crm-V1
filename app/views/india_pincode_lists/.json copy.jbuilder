json.array!(@india_pincode_lists) do |india_pincode_list|
  json.extract! india_pincode_list, :id, :officename, :pincode, :deliverystatus, :divisionname, :regionname, :circlename, :taluk, :districtname, :statename
  json.url india_pincode_list_url(india_pincode_list, format: :json)
end
