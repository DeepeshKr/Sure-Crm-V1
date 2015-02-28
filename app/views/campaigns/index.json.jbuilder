json.array!(@campaigns) do |campaign|
  json.extract! campaign, :id, :name, :startdate, :enddate, :mediumid, :description
  json.url campaign_url(campaign, format: :json)
end
