class OrderPayment < ActiveRecord::Base
	
  belongs_to :orderpaymentmode, foreign_key: "orderpaymentmode_id"
  belongs_to :order_master, foreign_key: "order_master_id"
  
  validates :order_master_id, uniqueness: { message: "Order ref id has been used" } #presence: true,
  validates :employee_id, presence: { message: "Employee Id is required" }
  validates :orderpaymentmode_id, presence:{ message: "Payment Mode is required" }
  
  validates :ref_no, allow_blank: true, presence: { message: "Reference no required" } #
  validates :paid_amount, presence: { message: "It is important to enter paid amount" } #allow_blank: true,
  
  # process update of paid 
  def process_order_payment
    
    return "No Order Paid Date not found, order NOT PROCESSED" if self.paid_date.blank?
    return "No Order Paid Amount not found, order NOT PROCESSED" if self.paid_amount.blank?
    return "No Order Ref Name not found, order NOT PROCESSED" if self.name.blank? 
    return "No Order Ref Id not found, order NOT PROCESSED" if self.order_master_id.blank? 
    
    return "Paid Amount #{self.paid_amount} is less than ORDER AMOUNT #{self.order_master.grand_total}" if self.paid_amount.to_i < self.order_master.grand_total.to_i
    
    order_master = OrderMaster.new
   return order_master.process_order self.order_master_id
    
  end
end
