class OrderFinalStatus < ActiveRecord::Base
	has_many :order_master, foreign_key: "order_final_status_id"
	has_many :vpp_deal_tran, foreign_key: "order_final_status_id" 
end
