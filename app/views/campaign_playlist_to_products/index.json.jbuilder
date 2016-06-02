json.array!(@campaign_playlist_to_products) do |campaign_playlist_to_product|
  json.extract! campaign_playlist_to_product, :id, :name, :campaign_playlist_id, :product_variant_id
  json.url campaign_playlist_to_product_url(campaign_playlist_to_product, format: :json)
end
