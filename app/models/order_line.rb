class OrderLine < ActiveRecord::Base
  belongs_to :order_master, foreign_key: "orderid"

  belongs_to :order_line_dispatch_status, foreign_key: "orderlinestatusmaster_id"
  belongs_to :product_variant, foreign_key: "productvariant_id" #, polymorphic: true
  belongs_to :product_list, foreign_key: "product_list_id"
  belongs_to :order_status_master #, polymorphic: true

  belongs_to :product_list, foreign_key: "product_list_id"
  belongs_to :product_master, foreign_key: "product_master_id"
  has_many :sales_ppo, foreign_key: "order_line_id"

  validates :pieces ,  :presence => { :message => "Please select no of pieces!" }
  validates :orderid,  :presence => { :message => "Please add an order first!" }
  validates :product_list_id,  :presence => { :message => "Please add a product!" }

#auto fill requirement
#delegate :product, to: :product_variant, prefix: true

  #after_create :updateorder # :creator

  after_save :updateorder # :updator

  #after_update :updateorder

  after_destroy :updateorder

# def self.to_csv(options = {})
#   CSV.generate(options) do |csv|
#     csv.add_row column_names
#     all.each do |foo|
#       values = foo.attributes.values
#       csv.add_row values
#     end
#   end
# end
# def self.to_csv_with_bar(options = {})
#   CSV.generate(options) do |csv|
#     csv.add_row column_names + self.bar.column_names

#     all.each do |foo|

#       values = foo.attributes.values

#       if foo.bar
#         values += foo.bar.attributes.values
#       end

#       csv.add_row values
#     end
#   end
# end
# def self.to_csv(foo_attributes = column_names, bar_attributes = bar.column_names, options = {})

#   CSV.generate(options) do |csv|
#     csv.add_row foo_attributes + bar_attributes

#     all.each do |foo|

#       values = foo.attributes.slice(*foo_attributes).values

#       if foo.contact_details
#         values += foo.contact_details.attributes.slice(*bar_attributes).values
#       end

#       csv.add_row values
#     end
#   end
# end

def codcharges
codcharges = 0
  if (self.orderid).present?
     codcharges = 0
     if self.product_master.sel_cod.blank? || self.product_master.sel_cod == 1

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
           if self.order_master.orderpaymentmode_id != 10001
            return  0
           end
        end
    end
  end
    return codcharges.round(2)
end

def creditcardcharges
  creditcardcharges = 0
  if (self.orderid).present?
    if self.product_master.sel_cc.blank? || self.product_master.sel_cc == 1

      creditcardid = 10000
      charges = Orderpaymentmode.find(creditcardid).charges
      if self.order_master.orderpaymentmode_id.present?
         #check if paid using cash on delivery is selected or atom not selected
         if self.order_master.orderpaymentmode_id == 10001
            charges = 0
         end
      end

      if self.product_variant.product_sell_type_id != 10000 #or self.product_variant.product_sell_type_id != 10060
            charges = 0
      end

      return ((self.subtotal || 0)  * (charges || 0)).round(2)

    end
    return creditcardcharges
  end
end

#service it levied on COD charges only at 12.36%
def servicetax
  if (self.orderid).present?
    servicetax = 0
    if self.product_master.sel_s_tax.blank? || self.product_master.sel_s_tax == 1

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

      #check if paid using credit card is selected
      if self.order_master.orderpaymentmode_id.present?
         if self.order_master.orderpaymentmode_id == 10000
          return  0
         end
      end

    end

  end

 return servicetax.round(2)
end

def maharastracodextra
  if (self.orderid).present?
     maharastracodextra = 0
    if self.product_master.sel_m_cod.blank? || self.product_master.sel_m_cod == 1

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


        #check if payment using any other mode is selected like
        # payumoney atom cc credit card
         if self.order_master.orderpaymentmode_id.present?
            if self.order_master.orderpaymentmode_id != 10001
             return  0
            end
         end

    end
  return maharastracodextra.round(2)
  end
end

def maharastraccextra
  maharastraccextra = 0
  if (self.orderid).present?

    if self.product_master.sel_m_cc.blank? || self.product_master.sel_m_cc == 1

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
  end
  return maharastraccextra.round(2)

end

def productcost
  pcode = self.product_list.product_variant.extproductcode
  cost_master =  ProductCostMaster.where("prod = ?", pcode).first
  if cost_master.present?
    return cost_master.cost * self.pieces || 0
  else
    return 0
  end
end

def product_shipping_cost
  pcode = self.product_list.product_variant.extproductcode
  cost_master =  ProductCostMaster.where("prod = ?", pcode).first
  if cost_master.present?
    return cost_master.shipping_handling * self.pieces || 0
  else
    return 0
  end
end

def product_postage
  pcode = self.product_list.product_variant.extproductcode if self.product_list

  return 0 if pcode.blank?
  cost_master = ProductCostMaster.where("prod = ?", pcode).where("postage is not null")

  if cost_master.present?
    return cost_master.first.postage * self.pieces || 0
  end
  return 0
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
  totalrevenue += (self.subtotal * (self.pieces ||= 1) * 0.888889) || 0
  totalrevenue += (self.shipping * (self.pieces ||= 1) * 0.98125) || 0
  return totalrevenue
end

def transfer_order_revenue
  total = 0
  total += (self.subtotal * (self.pieces ||= 1)) || 0
  total += (self.shipping * (self.pieces ||= 1)) || 0
  return total * 0.764444444445
end

def transfer_order_dealer_price
  total = 0
  total += (self.subtotal * (self.pieces ||= 1)) || 0
  total += (self.shipping * (self.pieces ||= 1)) || 0
  return total * 0.88888888889
end

def gross_sales
  totalrevenue = 0
  totalrevenue += (self.subtotal * (self.pieces ||= 1)) || 0
  totalrevenue += (self.shipping * (self.pieces ||= 1)) || 0
  return totalrevenue
end

def net_sales
  totalrevenue = 0
  totalrevenue += (self.subtotal * (self.pieces ||= 1) * 0.888889) || 0
  totalrevenue += (self.shipping * (self.pieces ||= 1) * 0.98125) || 0
  return totalrevenue
end

def refund
  # return
  totalrevenue = 0
  totalrevenue += (self.subtotal * (self.pieces ||= 1)) || 0
  totalrevenue += (self.shipping * (self.pieces ||= 1)) || 0
  return totalrevenue * 0.02
end

def media_commission
   media_variable = Medium.where('id = ? AND value is not null', self.order_master.media_id)
    .where(:media_commision_id => [10020, 10021, 10040, 10041, 10060]) #.pluck(:value)
  if media_variable.present?
         #discount the total value by 50% as media_correction
       media_correction = 1.0
       #PAID_CORRECTION
    if media_variable.first.paid_correction.present?
     media_correction = media_variable.first.paid_correction #||= 0.5
    end
    total_commission = 0
    total_commission += ((self.subtotal * 0.888889) * media_variable.first.value.to_f)  * media_correction if media_variable.first.value.present?
    if total_commission > 0
      total_commission += ((self.subtotal * 0.888889) * media_variable.first.agent_comm.to_f)  * media_correction if media_variable.first.agent_comm.present?
    end
    return total_commission
  else
    return 0
  end
end

def call_centre_commission
  #            .where.not('PRODUCT_VARIANTS.product_sell_type_id = ?', 10000).each do |ord| upsell_products << " #{ord.product_variant.extproductcode}
  ext_prod_code = self.product_variant.extproductcode
  if ProductVariant.where(extproductcode: ext_prod_code ).where("product_sell_type_id != ?", 10000).present?

  product_cost = ProductCostMaster.where('prod = ?', self.product_variant.extproductcode)
    #.pluck(:value)
    if product_cost.present?
       return product_cost.first.call_centre_commission
    else
      return 0
    end
  else
    return 0
  end
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
