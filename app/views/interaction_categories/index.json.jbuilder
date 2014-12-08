json.array!(@interaction_categories) do |interaction_category|
  json.extract! interaction_category, :id, :name, :sortorder, :employeeid, :resolutionhours
  json.url interaction_category_url(interaction_category, format: :json)
end
