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


  after_save :updateorder # :updator
  after_destroy :updateorder

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

      if (self.product_variant.product_sell_type_id != 10000) && (check_if_replacement(self.product_list_id) == "false")
            charges = 0
      end

      return ((self.subtotal || 0)  * (charges || 0)).round(2)

    end
    return creditcardcharges
  end
end

def check_if_replacement product_list_id
        add_on_replacements = ProductMasterAddOn.where("activeid = 10000 AND replace_by_product_id IS NOT NULL").pluck(:product_list_id)

       return add_on_replacements.include? product_list_id
       # ['Cat', 'Dog', 'Bird'].include? 'Dog'
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

def show_cc_savings
  creditcardcharges = 0
  if (self.orderid).present?
    if self.product_master.sel_cc.blank? || self.product_master.sel_cc == 1
      creditcardid = 10000
      charges = Orderpaymentmode.find(creditcardid).charges

      if (check_if_replacement(self.product_list_id) == "false")
        charges = 0
      end
      return ((self.subtotal || 0)  * (charges || 0)).round(2)
      
    end
    return creditcardcharges
  end
end

def maharastracc_savings
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

    end
  end
  return maharastraccextra.round(2)

end

def productcost
  # pcode = self.product_variant_id
  cost_master =  ProductCostMaster.where(product_variant_id: self.productvariant_id).first
  if cost_master.present?
    return cost_master.cost * self.pieces || 0
  else
    return 0
  end
end

def product_shipping_cost
  # pcode = self.product_variant_id
  cost_master =  ProductCostMaster.where(product_variant_id: self.productvariant_id).first
   if cost_master.present?
    return cost_master.shipping_handling * self.pieces || 0
  else
    return 0
  end
end

def product_postage
  cost_master =  ProductCostMaster.where(product_variant_id: self.productvariant_id).where("postage is not null")

  if cost_master.present?
    return cost_master.first.postage * self.pieces || 0
  end
  return 0
end

######## product pricing change for ppo start #########

def productrevenue
  vat_rate = TaxRate.find_by_name("VAT")
  shipping_rate = TaxRate.find_by_name("Shipping Reverse for PPO")
  
    totalrevenue = 0
    totalrevenue += (self.subtotal * (self.pieces ||= 1) * vat_rate.reverse_rate.to_f) || 0
    totalrevenue += (self.shipping * (self.pieces ||= 1) * shipping_rate.reverse_rate.to_f) || 0
     return totalrevenue
end

def gross_sales
  totalrevenue = 0
    totalrevenue += (self.subtotal * (self.pieces ||= 1)) || 0
    totalrevenue += (self.shipping * (self.pieces ||= 1)) || 0
     return totalrevenue
end

def net_sales
  vat_rate = TaxRate.find_by_name("VAT")
  shipping_rate = TaxRate.find_by_name("Shipping Reverse for PPO")
  totalrevenue = 0
  totalrevenue += (self.subtotal * (self.pieces ||= 1) * vat_rate.reverse_rate.to_f) || 0
  totalrevenue += (self.shipping * (self.pieces ||= 1) * shipping_rate.reverse_rate.to_f) || 0
  return totalrevenue
end

def transfer_order_revenue
  transfer_order = TaxRate.find_by_name("Transfer Order Reverse Rate")
   total = 0
  total += (self.subtotal * (self.pieces ||= 1)) || 0
  total += (self.shipping * (self.pieces ||= 1)) || 0
   return total * transfer_order.reverse_rate.to_f
end

def transfer_order_dealer_price
  vat_rate = TaxRate.find_by_name("VAT")
  total = 0
  total += (self.subtotal * (self.pieces ||= 1)) || 0
  total += (self.shipping * (self.pieces ||= 1)) || 0
  return total * vat_rate.reverse_rate.to_f # 0.88888888889
end

def refund
  # return
  totalrevenue = 0
  totalrevenue += (self.subtotal * (self.pieces ||= 1)) || 0
  totalrevenue += (self.shipping * (self.pieces ||= 1)) || 0
  return totalrevenue * 0.02
end

def media_commission
  return 0
end

def fixed_media_commision_percent
  media_variable = Medium.where('id = ? AND value is not null', self.order_master.media_id)
   .where(:media_commision_id => [10020]) #.pluck(:value)
   return 0 if media_variable.blank?

   return media_variable.first.value.to_f
end

def variable_media_commision_percent
  media_variable = Medium.where('id = ? AND value is not null', self.order_master.media_id)
   .where(:media_commision_id => [10020, 10040, 10041, 10060]) #.pluck(:value)
   return 0 if media_variable.blank?

   return media_variable.first.value.to_f
end

def fixed_media_agent_commision_percent
  media_variable = Medium.where('id = ? AND value is not null', self.order_master.media_id)
   .where(:media_commision_id => [10020]) #.pluck(:value)
   return 0 if media_variable.blank?

   return media_variable.first.agent_comm.to_f
end

def variable_media_agent_commision_percent
  media_variable = Medium.where('id = ? AND value is not null', self.order_master.media_id)
   .where(:media_commision_id => [10021, 10040, 10041, 10060]) #.pluck(:value)
   return 0 if media_variable.blank?

   return media_variable.first.agent_comm.to_f
end

def fixed_media_commission
  vat_rate = TaxRate.find_by_name("VAT")
  # Based on Orders Generated = 10020 (to be loaded as cost on paid orders)
   media_variable = Medium.where('id = ? AND value is not null', self.order_master.media_id)
    .where(:media_commision_id => [10020]) #.pluck(:value)
  if media_variable.present?
         #discount the total value by 50% as media_correction
       media_correction = 1.0
       #PAID_CORRECTION
    if media_variable.first.paid_correction.present?
     media_correction = media_variable.first.paid_correction #||= 0.5
    end
    total_commission = 0
    total_commission += ((self.subtotal * vat_rate.reverse_rate.to_f) * media_variable.first.value.to_f)  * media_correction if media_variable.first.value.present?
    if total_commission > 0
      total_commission += ((self.subtotal * vat_rate.reverse_rate.to_f) * media_variable.first.agent_comm.to_f)  * media_correction if media_variable.first.agent_comm.present?
    end
    return total_commission
  else
    return 0
  end
end

def variable_media_commission
  vat_rate = TaxRate.find_by_name("VAT")
   media_variable = Medium.where('id = ? AND value is not null', self.order_master.media_id)
    .where(:media_commision_id => [10021, 10040, 10041, 10060]) #.pluck(:value)
  if media_variable.present?
         #discount the total value by 50% as media_correction
       media_correction = 1.0
       #PAID_CORRECTION
      if (media_variable.first.media_commision_id == 10060 || media_variable.first.media_commision_id == 10041)
        #retail_def = 45.00
        retail_def = SalesPpoDefault.find_by_name("Retail").value
        #transfer_def = 65.00
        transfer_def = SalesPpoDefault.find_by_name("Transfer Order").value
        media_correction = retail_def.to_f
        media_correction = retail_def.to_f / 100

      end
    # if media_variable.first.paid_correction.present?
    #  media_correction = media_variable.first.paid_correction #||= 0.5
    # end
    total_commission = 0
    total_commission += ((self.subtotal * vat_rate.reverse_rate.to_f) * media_variable.first.value.to_f)  * media_correction if media_variable.first.value.present?
    if total_commission > 0
      total_commission += ((self.subtotal * vat_rate.reverse_rate.to_f) * media_variable.first.agent_comm.to_f)  * media_correction if media_variable.first.agent_comm.present?
    end
    return total_commission
  else
    return 0
  end
end



def financing_cost
  finance_charges = Orderpaymentmode.where('id = ? AND payment_cost is not null', self.order_master.orderpaymentmode_id)
  total_charge = 0
  if finance_charges.present?
    total_charge = ((self.shipping + self.subtotal) * (self.pieces ||= 1) * finance_charges.first.payment_cost.to_f || 0) || 0
  end

  return total_charge
end

######## product pricing change for ppo end #########

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
