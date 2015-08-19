class Promotion < ActiveRecord::Base
	has_many :order_master, foreign_key: "promotion_id"
	belongs_to :medium, foreign_key: "media_id"
end
