class OrderLine < ActiveRecord::Base
  belongs_to :order_master, foreign_key: "orderid"

  belongs_to :order_line_dispatch_status
  belongs_to :product_variant, foreign_key: "productvariant_id" #, polymorphic: true
  belongs_to :order_status_master #, polymorphic: true

validates_presence_of :productvariant_id, :pieces

validates :productvariant_id,  :presence => { :message => "Please add a product!" } 

#auto fill requirement
#delegate :product, to: :product_variant, prefix: true

after_create :creator

after_save :updator

after_destroy :updateOrder  

def codcharges
  cashondeliveryid = 10001
  charges = Orderpaymentmode.find(cashondeliveryid).charges
  return self.total * charges
end

def creditcardcharges
  creditcardid = 10000
  charges = Orderpaymentmode.find(creditcardid).charges
  return self.total * charges
end

def maharastraextra
  #2.5% extra charge
  return self.total * 0.025
end

def productrevenue
  pcode = self.product_variant.product_master.extproductcode
 ropmaster = ROPMASTER_NEW.where("prod = ?", pcode).first
 if ropmaster.present?
    return ropmaster.totalrevenue * self.pieces || 0
 else
    return 0
 end
  
end

def productcost
  pcode = self.product_variant.product_master.extproductcode
  ropmaster =  ROPMASTER_NEW.where("prod = ?", pcode).first
  if ropmaster.present?
    return ropmaster.totalcost * self.pieces || 0
 else
    return 0
 end
  
end

private
  #campaign_playlist_id in orderline
  #add to campaign
  def creator
  	productv = ProductVariant.find(self.productvariant_id)

    self.update_columns(subtotal: productv.price * self.pieces, 
    taxes: productv.taxes * self.pieces,
    codcharges: 0 * self.pieces,
    shipping: productv.shipping * self.pieces,
    total: productv.total * self.pieces,
    description: productv.name) # This will skip validation gracefully.

     self.update(description: productv.name)
     
    updateOrder
  end

def updator
  	productv = ProductVariant.find(self.productvariant_id)

    self.update_columns(subtotal: productv.price * self.pieces, 
    taxes: productv.taxes * self.pieces,
    codcharges: 0 * self.pieces,
    shipping: productv.shipping * self.pieces,
    total: productv.total * self.pieces,
    description: productv.name) # This will skip validation gracefully.

    self.update(description: productv.name)

updateOrder

     #self.update_column(pieces: 0,subtotal: 0, taxes: 0, codcharges: 0, shipping:0, total: 0)
  end

def updateOrder

	order_master = OrderMaster.find(self.orderid)
 order_lines = OrderLine.find_by orderid: self.orderid


 order_master.update(pieces: OrderLine.where('orderid = ?', self.orderid).sum(:pieces),
     subtotal: OrderLine.where('orderid = ?', self.orderid).sum(:subtotal),
     shipping: OrderLine.where('orderid = ?', self.orderid).sum(:shipping), 
    	taxes:  OrderLine.where('orderid = ?', self.orderid).sum(:taxes), 
    	codcharges: OrderLine.where('orderid = ?', self.orderid).sum(:codcharges), 
    	total: OrderLine.where('orderid = ?', self.orderid).sum(:total))
end

end
