json.array!(@campaign_playlists) do |campaign_playlist|
  json.extract! campaign_playlist, :id, :name, :campaignid, :starttime, :endtime, :productvariantid, :filename, :description
  json.url campaign_playlist_url(campaign_playlist, format: :json)
end
