class OrderLine < ActiveRecord::Base
  belongs_to :order_master, foreign_key: "orderid"

  belongs_to :order_line_dispatch_status, foreign_key: "orderlinestatusmaster_id"
  belongs_to :product_variant, foreign_key: "productvariant_id" #, polymorphic: true
  belongs_to :product_list, foreign_key: "product_list_id"
  belongs_to :order_status_master #, polymorphic: true

  belongs_to :product_list, foreign_key: "product_list_id"


  validates :pieces ,  :presence => { :message => "Please select no of pieces!" }
  validates :orderid,  :presence => { :message => "Please add an order first!" } 
  validates :product_list_id,  :presence => { :message => "Please add a product!" } 

#auto fill requirement
#delegate :product, to: :product_variant, prefix: true

  after_create :updateorder # :creator

  after_save :updateorder # :updator

  after_update :updateorder

  after_destroy :updateorder  

def codcharges
codcharges = 0
  if (self.orderid).present? 
    
    cashondeliveryid = 10001
    cashondeliverycharge = Orderpaymentmode.find(cashondeliveryid).charges

    # maharastracodextraid = 10020
    # maharastracodcharge = Orderpaymentmode.find(maharastracodextraid).charges
    # maharastracodextra = self.total * maharastracodcharge
    # #add all charges
    codcharges = ((self.total || 0 )) * (cashondeliverycharge || 0) 
    
    #check if address is selected
    if self.order_master.customer_address_id.present?
     #check if state is maharastra
      if self.order_master.customer_address.state.upcase == 'MAHARASHTRA'
         codcharges = ((self.total || 0 )) * (cashondeliverycharge || 0) 
      else
        codcharges = ((self.total || 0 )) * (cashondeliverycharge || 0) 
      end
    end
     #check if paid using credit card is selected
  if self.order_master.orderpaymentmode_id.present?
     if self.order_master.orderpaymentmode_id == 10000
      return  0
     end
  end
  
  end
    return codcharges.round(2)
end

def creditcardcharges
  if (self.orderid).present? 
  creditcardid = 10000
  charges = Orderpaymentmode.find(creditcardid).charges
  if self.order_master.orderpaymentmode_id.present?
     #check if paid using cash on delivery is selected
     if self.order_master.orderpaymentmode_id == 10001
        charges = 0
     end
  end


  return ((self.subtotal || 0)  * (charges || 0)).round(2)

  end
end

#service it levied on COD charges only at 12.36%
def servicetax
  if (self.orderid).present? 
    servicetaxid = 10040
    servicetaxrate = Orderpaymentmode.find(servicetaxid).charges 
   
     maharastracodextraid = 10020
     maharastracodextrarate = Orderpaymentmode.find(maharastracodextraid).charges

     maharastracodextracharge = self.total * maharastracodextrarate

    cashondeliveryid = 10001
    cashondeliveryrate = Orderpaymentmode.find(cashondeliveryid).charges
    cashondeliverycharge = self.total * cashondeliveryrate

     
    
    #add all charges
    servicetax = ((maharastracodextracharge || 0) + (cashondeliverycharge || 0)) * (servicetaxrate || 0)

    #check if address is selected
    if self.order_master.customer_address_id.present?
       #check if state is maharastra
       if self.order_master.customer_address.state.upcase == 'MAHARASHTRA'
       
        servicetax = ((maharastracodextracharge || 0) + (cashondeliverycharge || 0)) * (servicetaxrate || 0)
       else
        servicetax =  (cashondeliverycharge || 0) * (servicetaxrate || 0)


       end
    end

  end
 
  #check if paid using credit card is selected
  if self.order_master.orderpaymentmode_id.present?
     if self.order_master.orderpaymentmode_id == 10000
      return  0
     end
  end

 return servicetax.round(2)

end

def maharastracodextra
  if (self.orderid).present? 
    surchargeid = 10020
    maharastracodcharge = Orderpaymentmode.find(surchargeid).charges

    cashondeliveryid = 10001
    cashondeliverycharge = Orderpaymentmode.find(cashondeliveryid).charges
     codcharges = ((self.total || 0 )) * (cashondeliverycharge || 0) 

    maharastracodextra = (self.total + codcharges) * maharastracodcharge
      #check if address is selected
    if self.order_master.customer_address.present?
     #check if state is maharastra
     if self.order_master.customer_address.state.upcase == 'MAHARASHTRA'
        maharastracodextra = (self.total + codcharges) * maharastracodcharge
     else
        maharastracodextra = 0
     end
    end
  end
 #check if paid using credit card is selected
  if self.order_master.orderpaymentmode_id.present?
     if self.order_master.orderpaymentmode_id == 10000
      return  0
     end
  end
return maharastracodextra.round(2)

end

def maharastraccextra
  maharastraccextra = 0
  if (self.orderid).present? 
  
  creditcardid = 10000
  creditcardcharges = Orderpaymentmode.find(creditcardid).charges
  creditcardtotal = (self.subtotal || 0)  * (creditcardcharges || 0)

   surchargeid = 10020
  surcharge = Orderpaymentmode.find(surchargeid).charges
  

  maharastraccextra =  (self.subtotal + creditcardtotal + self.shipping) * surcharge

    #check if address is selected
    if self.order_master.customer_address.present?
       #check if state is maharastra
      if self.order_master.customer_address.state.upcase == 'MAHARASHTRA'
           maharastraccextra =  (self.subtotal + creditcardtotal + self.shipping) * surcharge
       else
          maharastraccextra = 0
      end
    end
    
 #check if paid using cash on delivery is selected
  if self.order_master.orderpaymentmode_id.present?
     if self.order_master.orderpaymentmode_id == 10001
      return  0
     end
  end

end
  return maharastraccextra.round(2)

end

def productcost
   if self.product_list.present? #&& self.pieces.present?
    pcode = self.product_list.extproductcode
    cost_master =  ProductCostMaster.where("prod = ?", pcode).first
      if cost_master.present?
          return cost_master.cost * self.pieces || 0
     else
        return 0
     end
  else
    return 0
  end
end

# def productcost
#    if self.product_list.present? #&& self.pieces.present?
#     pcode = self.product_list.extproductcode
#     ropmaster =  ROPMASTER_NEW.where("prod = ?", pcode).first
#       if ropmaster.present?
#           return ropmaster.totalcost #* self.pieces || 0
#      else
#         return 0
#      end
#   else
#     return 0
#   end
# end

def productrevenue
  totalrevenue = 0
    totalrevenue += ((self.subtotal * self.pieces) * 0.888889)|| 0
    totalrevenue += ((self.shipping * self.pieces) *0.98125)|| 0
     return totalrevenue
end 
# def productrevenue
#   if self.product_list.present? #&& self.pieces.present?
#     pcode = self.product_list.extproductcode
#     ropmaster = ROPMASTER_NEW.where("prod = ?", pcode).first
#     if ropmaster.present?
#         if self.subtotal > 0
#           return ropmaster.totalrevenue #* self.pieces || 0
#         else
#           return 0
#         end
#     else
#       return 0
#     end
#   else
#       return 0
#     end
# end 



private
  #campaign_playlist_id in orderline
  #add to campaign
  def creator
  	productlist = ProductList.find(self.product_list_id)

    self.update_columns(subtotal: productv.price * self.pieces, 
    taxes: productv.taxes * self.pieces,
    codcharges: 0 * self.pieces,
    shipping: productv.shipping * self.pieces,
    total: productv.total * self.pieces,
    description: productv.name) # This will skip validation gracefully.

     self.update(description: productlist.productlistdetails)
     
    #updateOrder
  end

def updator
  	productlist = ProductList.find(self.product_list_id)

    self.update_columns(subtotal: productv.price * self.pieces, 
    taxes: productv.taxes * self.pieces,
    codcharges: 0 * self.pieces,
    shipping: productv.shipping * self.pieces,
    total: productv.total * self.pieces,
    description: productv.name) # This will skip validation gracefully.

    self.update(description: productlist.productlistdetails)
end

def updateorder
    if (self.orderid).present? 
      order_master = OrderMaster.find(self.orderid)
    
      order_master.update_columns(pieces: OrderLine.where('orderid = ?', self.orderid).sum(:pieces),
       subtotal: OrderLine.where('orderid = ?', self.orderid).sum(:subtotal),
       shipping: OrderLine.where('orderid = ?', self.orderid).sum(:shipping), 
      	taxes:  OrderLine.where('orderid = ?', self.orderid).sum(:taxes), 
      	codcharges: OrderLine.where('orderid = ?', self.orderid).sum(:codcharges), 
      	total: OrderLine.where('orderid = ?', self.orderid).sum(:total))
    end
end

end
