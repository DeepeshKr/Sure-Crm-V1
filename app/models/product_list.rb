class ProductList < ActiveRecord::Base

  belongs_to :product_variant, foreign_key: "product_variant_id"
  belongs_to :product_master, foreign_key: "product_master_id" 
  belongs_to :product_spec_list, foreign_key: "product_spec_list_id" 
  belongs_to :product_active_code, foreign_key: "active_status_id"
  
  has_many :product_master_add_on, foreign_key: "product_list_id"
  has_many :product_sample_stock, foreign_key: "product_list_id"
  has_many :product_cost_master, foreign_key: "product_list_id" 
  belongs_to :promotion, foreign_key: "free_product_list_id"

  #has_many :product_master_add_on, :class_name => 'PointOfContact',  foreign_key: "replace_by_product_id"
  #coding not completed for this
  #has_many :interaction_master, foreign_key: "productvariantid"
    
    #ordering is related to this
    has_many :order_line, foreign_key: "product_list_id" #, polymorphic: true
    validates_presence_of :extproductcode
    validates_presence_of :list_barcode
    #validates_uniqueness_of :list_barcode, :allow_blank => true, :message => "This code has been used earlier, you may choose to leave it blank! "

    validates_uniqueness_of :name, :scope => [:product_variant_id, :product_spec_list_id], :message => "Not Saved, a variant has been saved earlier with the same spec! "



  def productinfo
     self.name << " (" << self.extproductcode << ")"
   end

   def productlistdetails
    if self.product_variant_id.present?

   if ProductVariant.where(id: self.product_variant_id).present?
      product_variant = ProductVariant.find(self.product_variant_id)
      self.name << " Price:" << product_variant.price.to_s << " Shipping:" << product_variant.shipping.to_s << " (" << self.extproductcode << ")"
    end
  end
  end

   def price
    if self.product_variant_id.present?
      if ProductVariant.where(id: self.product_variant_id).present?
        product_variant = ProductVariant.find(self.product_variant_id)
        
        return "Basic Price : " << (product_variant.price || 0).to_s << "  Shipping : " << (product_variant.shipping || 0).to_s
      end
    end
  end

  def shipping
    if self.product_variant_id.present?
      if ProductVariant.find(self.product_variant_id).present?
      product_variant = ProductVariant.find(self.product_variant_id)
      
      return  "Shipping : " << (product_variant.shipping || 0).to_i.to_s
      end
    end
  end
   #:sel_cod  => 1, :  => 1, :sel_m_cod  => 1,
     #  :  => 1, : => 1)
  def codcharges

      price = (product_variant.price  || 0) + (product_variant.shipping || 0)

      # surchargeid = 10020
      # surcharge = 1 + Orderpaymentmode.find(surchargeid).charges
      # total = price * surcharge
      total = price
      if self.product_master.sel_cod.blank? || self.product_master.sel_cod == 1
        cashondeliveryid = 10001
        charges = 1 + Orderpaymentmode.find(cashondeliveryid).charges
        total = total * charges

        servicetaxid = 10040
        servicetax = 1 + Orderpaymentmode.find(servicetaxid).charges
        servicetaxcharges = (price * Orderpaymentmode.find(cashondeliveryid).charges ) * Orderpaymentmode.find(servicetaxid).charges
        
        total = total + servicetaxcharges
      end
          
    return total
  end

  def maharastracodextra
      price = (product_variant.price  || 0) + (product_variant.shipping || 0)
      total = price
     
      if self.product_master.sel_m_cod.blank? || self.product_master.sel_m_cod == 1
           
      surchargeid = 10020
      surcharge = 1 + Orderpaymentmode.find(surchargeid).charges
      total = price * surcharge

      cashondeliveryid = 10001
      charges = 1 + Orderpaymentmode.find(cashondeliveryid).charges
      total = total * charges

      servicetaxid = 10040
      servicetax = 1 + Orderpaymentmode.find(servicetaxid).charges
      servicetaxcharges = (price * Orderpaymentmode.find(cashondeliveryid).charges ) * Orderpaymentmode.find(servicetaxid).charges
      
      total = total + servicetaxcharges
      end

    return total
  end

  def servicetax
    total = (product_variant.price  || 0) + (product_variant.shipping || 0)
    if self.product_master.sel_s_tax.blank? || self.product_master.sel_s_tax == 1
      cashondeliveryid = 10001
      codcharges = 1 + Orderpaymentmode.find(cashondeliveryid).charges

      surchargeid = 10020
      surcharge = 1 + Orderpaymentmode.find(surchargeid).charges

      servicetaxid = 10040
      servicetax = 1 + Orderpaymentmode.find(servicetaxid).charges
      total = total * codcharges * surcharge
     end
  return total 
  end

  def creditcardcharges
    total = (product_variant.price  || 0) + (product_variant.shipping || 0)
      if self.product_master.sel_cc.blank? || self.product_master.sel_cc == 1
        creditcardid = 10000
        charges = 1 +  Orderpaymentmode.find(creditcardid).charges
        total = ((product_variant.price  || 0) * charges ) + (product_variant.shipping || 0)
      end
    
    return total  
  end

  def maharastraccextra
    total = (product_variant.price  || 0) + (product_variant.shipping || 0)
    if self.product_master.sel_m_cc.blank? || self.product_master.sel_m_cc == 1
    
      creditcardid = 10000
      charges = 1 +  Orderpaymentmode.find(creditcardid).charges
      total = ((product_variant.price  || 0) * charges ) + (product_variant.shipping || 0) 

      surchargeid = 10020
      surcharge = 1 + Orderpaymentmode.find(surchargeid).charges
      total = total * surcharge
    end
    
    return total
  end

end
