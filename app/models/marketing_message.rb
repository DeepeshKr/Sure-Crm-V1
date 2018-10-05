class MarketingMessage < ActiveRecord::Base
  has_many :message_on_order, foreign_key: "marketing_message_id"
  belongs_to :orderpaymentmode, foreign_key: "order_paymentmodeid"
  
  # after_update :create_plan
 #  after_create :create_plan
  
  
  def create_plan
      order_masters = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10000')
          .where('TRUNC(orderdate) >= ? and TRUNC(orderdate) <= ?', self.start_date, self.end_date)
          .where(orderpaymentmode_id: self.order_paymentmodeid).pluck(:id).count()
          
      self.update(total_nos: order_masters, activate: 0)
  end
  
  def update_plan
    if self.activate == false
      order_masters = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10000')
          .where('TRUNC(orderdate) >= ? and TRUNC(orderdate) <= ?', self.start_date, self.end_date)
          .where(orderpaymentmode_id: self.order_paymentmodeid).pluck(:id).count()
          
      self.update(total_nos: order_masters)
    end
  end
  
  def generate_messeges
     if self.activate == true
       order_masters = OrderMaster.where('ORDER_STATUS_MASTER_ID > 10000')
           .where('TRUNC(orderdate) >= ? and TRUNC(orderdate) <= ?', self.start_date, self.end_date)
           .where(orderpaymentmode_id: self.order_paymentmodeid).pluck(:id)
           
           order_masters.each do |order|
             #message, order_id, marketing_message_id
            
             MessageOnOrder.marketing_messages self.description, order, self.id
           end
           #end loop
     end
     #end if
  end
  
end
