class SalesPpo < ActiveRecord::Base
  belongs_to :campaign_playlist, foreign_key: "campaign_playlist_id"
  belongs_to :order_status_master, foreign_key: "order_status_id"
   has_many :campaign, foreign_key: "campaign_id"
  belongs_to :order_master, foreign_key: "order_id"
  belongs_to :order_line, foreign_key: "order_line_id"
  belongs_to :medium, foreign_key: "media_id"
  belongs_to :promotion, foreign_key: "promotion_id"
  belongs_to :product_master, foreign_key: "product_master_id"
  belongs_to :product_variant, foreign_key: "product_variant_id"
  belongs_to :product_list, foreign_key: "product_list_id"

  validates :order_line_id,  allow_blank: true, uniqueness: true
end
