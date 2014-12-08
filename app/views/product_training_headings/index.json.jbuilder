json.array!(@product_training_headings) do |product_training_heading|
  json.extract! product_training_heading, :id, :name, :sortorder
  json.url product_training_heading_url(product_training_heading, format: :json)
end
