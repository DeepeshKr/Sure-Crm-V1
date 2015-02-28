json.array!(@product_training_manuals) do |product_training_manual|
  json.extract! product_training_manual, :id, :productid, :name, :description, :quicknotes
  json.url product_training_manual_url(product_training_manual, format: :json)
end
