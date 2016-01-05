json.array!(@campaign_missed_lists) do |campaign_missed_list|
  json.extract! campaign_missed_list, :id, :product_list_id, :product_variant_id, :productmaster_id, :external_prod, :reason, :description
  json.url campaign_missed_list_url(campaign_missed_list, format: :json)
end
