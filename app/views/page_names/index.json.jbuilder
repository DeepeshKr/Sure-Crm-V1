json.array!(@page_names) do |page_name|
  json.extract! page_name, :id, :name, :sort_order, :description
  json.url page_name_url(page_name, format: :json)
end
