class OrderDispatchStatus < ActiveRecord::Base
  has_many :pending_order, foreign_key: "order_dispatch_status_id"
end
