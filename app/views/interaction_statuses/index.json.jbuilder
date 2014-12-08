json.array!(@interaction_statuses) do |interaction_status|
  json.extract! interaction_status, :id, :customer_description, :internal_description, :sortorder
  json.url interaction_status_url(interaction_status, format: :json)
end
