class ProductList < ActiveRecord::Base

	belongs_to :product_variant, foreign_key: "product_variant_id" 
	belongs_to :product_spec_list, foreign_key: "product_spec_list_id" 
	belongs_to :product_active_code, foreign_key: "active_status_id"
	
  has_many :product_master_add_on, foreign_key: "product_list_id"
	#coding not completed for this
	#has_many :interaction_master, foreign_key: "productvariantid"
  	
  	#ordering is related to this
  	has_many :order_line, foreign_key: "product_list_id" #, polymorphic: true
  	validates_presence_of :extproductcode
  	validates_uniqueness_of :list_barcode, :allow_blank => true, :message => "This code has been used earlier, you may choose to leave it blank! "

  	validates_uniqueness_of :name, :scope => [:product_variant_id, :product_spec_list_id], :message => "Not Saved, a variant has been saved earlier with the same spec! "

  def productinfo
     self.name << " (" << self.extproductcode << ")"
   end

   def productlistdetails
    product_variant = ProductVariant.find(self.product_variant_id)
     self.name << " Price:" << product_variant.price.to_s << " Shipping:" << product_variant.shipping.to_s << " (" << self.extproductcode << ")"
   end

   def basic
      product_variant = ProductVariant.find(self.product_variant_id)
    return (product_variant.price || 0)
  end

  def shipping
      product_variant = ProductVariant.find(self.product_variant_id)
    return (product_variant.shipping || 0) 
  end
   def codcharges
      product_variant = ProductVariant.find(self.product_variant_id)
      cashondeliveryid = 10001
      charges = 1 +  Orderpaymentmode.find(cashondeliveryid).charges
    return ((product_variant.price  || 0) + (product_variant.shipping || 0)) * charges 
  end

  def creditcardcharges
    creditcardid = 10000
    charges = 1 +  Orderpaymentmode.find(creditcardid).charges
    return ((product_variant.price  || 0) + (product_variant.shipping || 0))  * charges 
  end

  def maharastraextra
    cashondeliveryid = 10001
    codcharges = 1 + Orderpaymentmode.find(cashondeliveryid).charges

    surchargeid = 10020
    surcharge = 1 + Orderpaymentmode.find(surchargeid).charges
    return (((product_variant.price  || 0) + (product_variant.shipping || 0)) * codcharges) * surcharge
  end

end
