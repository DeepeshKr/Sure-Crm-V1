class OrderMaster < ActiveRecord::Base
  belongs_to :campaign_playlist, foreign_key: "campaign_playlist_id"
  belongs_to :employee, foreign_key: "employee_id"
  belongs_to :order_source
  belongs_to :order_status_master, foreign_key: "order_status_master_id" #, polymorphic: true
  belongs_to :order_source
  belongs_to :orderpaymentmode,  foreign_key: "orderpaymentmode_id"
  belongs_to :customer, foreign_key: "customer_id" #, polymorphic: true
  belongs_to :customer_address, foreign_key: "customer_address_id" #, polymorphic: true
  belongs_to :medium, foreign_key: "media_id"
  has_many :order_line, foreign_key: "orderid", :dependent => :destroy
   
  accepts_nested_attributes_for :order_line,  :allow_destroy => true

  validates_presence_of :calledno , :mobile

  validates_associated :order_line

  #external order
  #order_for_id - Integer update with customer order id
  #external_order_no - string update with customer order id
  

#after_create :on_create

#after_save :on_upate

#after_update :on_update

after_destroy :updateOrder

  def no_order_master(attributes)
  attributes[:id].blank?
  end

  def codcharges
  productcost = OrderLine.where('orderid = ?', self.id)
  #return productcost.first.productcost
  if productcost.exists?
    total = 0
    productcost.each do |c|
      total += c.codcharges || 0
    end
    return total
    
  else
    return 0
  end
 
end

def creditcardcharges
 productcost = OrderLine.where('orderid = ?', self.id)
  #return productcost.first.productcost
  if productcost.exists?
    total = 0
    productcost.each do |c|
      total += c.creditcardcharges || 0
    end
    return total.to_i
    
  else
    return 0
  end
 
end

def maharastracodextra
 productcost = OrderLine.where('orderid = ?', self.id)
  #return productcost.first.productcost
  if productcost.exists?
    total = 0
    productcost.each do |c|
      total += c.maharastracodextra || 0

    end
    return total.to_i
    
  else
    return 0
  end
 
end

def servicetax
  productcost = OrderLine.where('orderid = ?', self.id)
  #return productcost.first.productcost
  if productcost.exists?
    total = 0
    productcost.each do |c|
      total += c.servicetax || 0

    end
    return total.to_i
    
  else
    return 0
  end

end

def maharastraccextra
 productcost = OrderLine.where('orderid = ?', self.id)
  #return productcost.first.productcost
  if productcost.exists?
    total = 0
    productcost.each do |c|
      total += c.maharastraccextra || 0

    end
    return total.to_i
    
  else
    return 0
  end
 
end

def totalCODCharges
 productcost = OrderLine.where('orderid = ?', self.id)
  #return productcost.first.productcost
  if productcost.exists?
    total = 0
    productcost.each do |c|
      total += c.maharastracodextra || 0
     total += c.codcharges || 0
    end
    return total.to_i
    
  else
    return 0
  end
 
end



def productcost
 productcost = OrderLine.where('orderid = ?', self.id)
  #return productcost.first.productcost
  if productcost.exists?
    total = 0
    productcost.each do |c|
      total += c.productcost
    end
    return total
    
  else
    return 0
  end
 
end
def productrevenue
  productrevenue = OrderLine.where('orderid = ?', self.id)

  if productrevenue.exists?
    total = 0
    productrevenue.each do |c|
      total += c.productrevenue
    end
    return total
    
  else
    return 0
  end
 
  #productcost.sum { |p| p.productrevenue }
  #

  #return OrderLine.where('orderid = ?', self.id).sum(:productrevenue)
end
private
  def on_create
  #self.update_column(pieces: 0,subtotal: 0, taxes: 0, codcharges: 0, shipping:0, total: 0)
  self.update(pieces: OrderLine.where('orderid = ?', self.id).sum(:pieces),
     subtotal: OrderLine.where('orderid = ?', self.id).sum(:subtotal),
     shipping: OrderLine.where('orderid = ?', self.id).sum(:shipping), 
      taxes:  OrderLine.where('orderid = ?', self.id).sum(:taxes), 
      codcharges: OrderLine.where('orderid = ?', self.id).sum(:codcharges), 
      total: OrderLine.where('orderid = ?', self.id).sum(:total))
  end

   def on_update
    self.update(pieces: OrderLine.where('orderid = ?', self.id).sum(:pieces),
     subtotal: OrderLine.where('orderid = ?', self.id).sum(:subtotal),
     shipping: OrderLine.where('orderid = ?', self.id).sum(:shipping), 
      taxes:  OrderLine.where('orderid = ?', self.id).sum(:taxes), 
      codcharges: OrderLine.where('orderid = ?', self.id).sum(:codcharges), 
      total: OrderLine.where('orderid = ?', self.id).sum(:total))
 
  end

   def on_destroy
    self.update(pieces: OrderLine.where('orderid = ?', self.id).sum(:pieces),
     subtotal: OrderLine.where('orderid = ?', self.id).sum(:subtotal),
     shipping: OrderLine.where('orderid = ?', self.id).sum(:shipping), 
      taxes:  OrderLine.where('orderid = ?', self.id).sum(:taxes), 
      codcharges: OrderLine.where('orderid = ?', self.id).sum(:codcharges), 
      total: OrderLine.where('orderid = ?', self.id).sum(:total))
  #self.update_column(pieces: 0,subtotal: 0, taxes: 0, codcharges: 0, shipping:0, total: 0)
  end
  
end
