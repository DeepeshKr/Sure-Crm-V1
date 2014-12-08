json.array!(@interaction_users) do |interaction_user|
  json.extract! interaction_user, :id, :name
  json.url interaction_user_url(interaction_user, format: :json)
end
