json.array!(@interaction_priorities) do |interaction_priority|
  json.extract! interaction_priority, :id, :name, :sortorder
  json.url interaction_priority_url(interaction_priority, format: :json)
end
