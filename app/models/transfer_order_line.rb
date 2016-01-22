class TransferOrderLine < ActiveRecord::Base
  belongs_to :transfer_order_master, foreign_key: "transfer_order_id"
  belongs_to :transfer_order_status, foreign_key: "transfer_order_status_id"
end
