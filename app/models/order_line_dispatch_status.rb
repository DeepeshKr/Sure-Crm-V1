class OrderLineDispatchStatus < ActiveRecord::Base
  has_many :order_lines, foreign_key: "orderlinestatusmaster_id"
end
