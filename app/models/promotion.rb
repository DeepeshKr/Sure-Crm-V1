class Promotion < ActiveRecord::Base
	belongs_to :medium, foreign_key: "media_id"
	belongs_to :product_list, foreign_key: "free_product_list_id"
  
	has_many :order_master, foreign_key: "promotion_id"
  has_many :sales_ppo, foreign_key: "promotion_id"
end
