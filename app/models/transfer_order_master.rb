class TransferOrderMaster < ActiveRecord::Base
  belongs_to :corporate, foreign_key: "corporate_id"
  belongs_to :customer, foreign_key: "customer_id"
  belongs_to :order_master, foreign_key: "order_id"

  has_many :transfer_order_line, foreign_key: "transfer_order_id"

  
end
