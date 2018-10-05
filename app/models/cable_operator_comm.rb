class CableOperatorComm < ActiveRecord::Base
  validates :order_id,  allow_blank: true, uniqueness: { message: "Order Ref Id has to unique" }
  validates :order_no,  allow_blank: true, uniqueness: { message: "Order No has to unique or has been used" }
end
