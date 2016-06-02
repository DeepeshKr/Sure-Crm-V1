class AddCampaignPlayListIdIndexToCampaignPlaylistToProduct < ActiveRecord::Migration
  def change
    add_index :campaign_playlist_to_products, :campaign_playlist_id
    add_index :campaign_playlist_to_products, :product_variant_id
  end
end
