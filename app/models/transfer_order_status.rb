class TransferOrderStatus < ActiveRecord::Base
  has_many :transfer_order_master, foreign_key: "transfer_order_status_id"
  has_many :transfer_order_line, foreign_key: "transfer_order_status_id"
end
