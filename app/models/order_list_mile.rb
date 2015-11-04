class OrderListMile < ActiveRecord::Base
	has_many :order_master, foreign_key: "order_last_mile_id"
	has_many :vpp_deal_tran, foreign_key: "order_last_mile_id"
end
