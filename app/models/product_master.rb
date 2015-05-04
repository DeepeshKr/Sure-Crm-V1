class ProductMaster < ActiveRecord::Base
  belongs_to :product_category, foreign_key: "productcategoryid"
  belongs_to :product_inventory_code, foreign_key: "productinventorycodeid"
  belongs_to :product_active_code, foreign_key: "productactivecodeid"
  belongs_to :product_sell_type , foreign_key: "product_sell_type_id"
  
  has_many :product_master_ann_on, foreign_key: "product_master_id"
  has_many :product_stock_book, foreign_key: "product_master_id"

  has_many :product_variant, foreign_key: "productmasterid" 
  belongs_to :product_training_manual, foreign_key: "productid"
  
  validates :barcode, uniqueness: { case_sensitive: false }
  validates :extproductcode, uniqueness: { case_sensitive: false }
  
  validates_associated :product_variant
  
  def productname
   self.barcode + " - " + self.name  + " Basic " + self.price.to_s + " Shipping " + self.shipping.to_s 
  end

  def fullproductname
   self.barcode  + " - " +  self.extproductcode + " - " + self.name  + " Basic " + self.price.to_s + " Shipping " + self.shipping.to_s 
  end

  def variants
    ProductVariant.where("productmasterid = ?", self.id)
  end

  def AddOn
    ProductMasterAddOn.where("product_master_id = ?", self.id)
  end
end
