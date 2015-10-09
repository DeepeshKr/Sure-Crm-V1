class Promotion < ActiveRecord::Base
	has_many :order_master, foreign_key: "promotion_id"
	belongs_to :medium, foreign_key: "media_id"
	belongs_to :product_list, foreign_key: "free_product_list_id"
end
