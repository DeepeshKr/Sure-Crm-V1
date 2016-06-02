class CampaignPlaylistToProduct < ActiveRecord::Base
  belongs_to :campaign_playlist, foreign_key: "campaign_playlist_id"
  belongs_to :product_variant, foreign_key: "product_variant_id"
  
  validates_presence_of :product_variant_id, :campaign_playlist_id
  validates_uniqueness_of :product_variant_id, :scope => :campaign_playlist_id
end
