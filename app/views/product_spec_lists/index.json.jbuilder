json.array!(@product_spec_lists) do |product_spec_list|
  json.extract! product_spec_list, :id, :name, :spec_1, :spec_2, :spec_3, :spec_4, :spec_5, :description
  json.url product_spec_list_url(product_spec_list, format: :json)
end
