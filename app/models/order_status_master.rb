class OrderStatusMaster < ActiveRecord::Base
   has_many :order_master, foreign_key: "order_status_master_id"
   #  has_many :order_lines, foreign_key: "orderlinestatusmaster_id"
   
end
