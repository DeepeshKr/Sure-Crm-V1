class ProductMaster < ActiveRecord::Base
  belongs_to :product_category, foreign_key: "productcategoryid"
  belongs_to :product_inventory_code, foreign_key: "productinventorycodeid"
  belongs_to :product_active_code, foreign_key: "productactivecodeid"
  belongs_to :product_sell_type , foreign_key: "product_sell_type_id"
  
  has_many :product_variant_add_ons, foreign_key: "product_master_id"
  has_many :product_variant, foreign_key: "productmasterid" 
  
  validates :barcode, uniqueness: { case_sensitive: false }
  validates :extproductcode, uniqueness: { case_sensitive: false }
  
  validates_associated :product_variant
  
  def productname
   self.barcode + " - " + self.name  + " Rs. " + self.total.to_s 
  end

  def variants
    ProductVariant.where("productmasterid = ?", self.id)
  end
end