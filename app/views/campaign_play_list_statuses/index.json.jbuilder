json.array!(@campaign_play_list_statuses) do |campaign_play_list_status|
  json.extract! campaign_play_list_status, :id, :name, :description
  json.url campaign_play_list_status_url(campaign_play_list_status, format: :json)
end
