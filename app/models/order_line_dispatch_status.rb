class OrderLineDispatchStatus < ActiveRecord::Base
  has_many :order_lines
end
