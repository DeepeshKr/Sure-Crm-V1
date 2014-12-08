json.array!(@campaign_stages) do |campaign_stage|
  json.extract! campaign_stage, :id, :name, :sortorder
  json.url campaign_stage_url(campaign_stage, format: :json)
end
