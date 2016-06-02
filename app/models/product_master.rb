class ProductMaster < ActiveRecord::Base
  belongs_to :product_category, foreign_key: "productcategoryid"
  belongs_to :product_inventory_code, foreign_key: "productinventorycodeid"
  belongs_to :product_active_code, foreign_key: "productactivecodeid"
  belongs_to :product_sell_type , foreign_key: "product_sell_type_id"
  
  has_many :product_master_add_on, foreign_key: "product_master_id"
  has_many :distributor_stock_ledger, foreign_key: "product_master_id"
  has_many :distributor_stock_summary, foreign_key: "product_master_id"
  
  #has_many :product_stock_book, foreign_key: "product_master_id"
  #has_many :product_stock, foreign_key: "product_master_id"
  #has_many :product_stock_adjust, foreign_key: "product_master_id"
  has_many :product_sample_stock, foreign_key: "product_master_id"

  has_many :product_variant, foreign_key: "productmasterid" 
  has_many :product_list, foreign_key: "product_master_id" 
  has_many :order_line, foreign_key: "product_master_id"  
  has_many :product_cost_master, foreign_key: "product_id" 
  has_many :sales_ppo, foreign_key: "product_master_id"
  
  belongs_to :product_training_manual, foreign_key: "productid"
  validates_presence_of :name
  #validates :barcode, uniqueness: { case_sensitive: false }
  validates :extproductcode, uniqueness: { case_sensitive: false }
  
  validates_associated :product_variant
  
  def productname
    if self.extproductcode.present?
        (self.extproductcode + " - " || "" if self.extproductcode.present?)  + (self.name || "" if self.name.present?) +  (" Basic " + self.price.to_s || "" if self.price.present?)  + ( " Shipping " + self.shipping.to_s || "" if self.shipping.present?) + " :(#{self.id})"
      else
        self.id.to_s + " " + (self.name || " no products details")
    end
  end

  def productlistname
  self.name + " - " + self.barcode + " Basic " + self.price.to_s + " Shipping " + self.shipping.to_s 
  end

  def fullproductname
   if self.extproductcode.present?
       self.barcode  + " - " +  (self.extproductcode || "0" if self.extproductcode.present?) + " - " + self.name  + " Basic " + (self.price.to_s || "0" if self.price.present?) + " Shipping " + (self.shipping.to_s || "0" if self.price.present? ) + " :(#{self.id})"
     else
        self.id.to_s + " " + (self.name || " no products details")
   end
  end

  def productrevenue
      #pcode = self.product_variant.product_master.extproductcode
     ropmaster = ROPMASTER_NEW.where("prod = ?", self.extproductcode).first
     if ropmaster.present?
        return ropmaster.totalrevenue || 0
     else
        return 0
     end
      
  end

  def productcost
    #pcode = self.product_variant.product_master.extproductcode
    ropmaster =  ROPMASTER_NEW.where("prod = ?", self.extproductcode).first
    if ropmaster.present?
      return ropmaster.totalcost || 0
   else
      return 0
   end
  end

   def packagingcost
    #pcode = self.product_variant.product_master.extproductcode
    ropmaster =  ROPMASTER_NEW.where("prod = ?", self.extproductcode).first
    if ropmaster.present?
      return ropmaster.totalcost || 0
   else
      return 0
   end
    
  end

  def variants
    ProductVariant.where("productmasterid = ?", self.id)
  end

  def AddOn
    ProductMasterAddOn.where("product_master_id = ?", self.id)
  end
end
