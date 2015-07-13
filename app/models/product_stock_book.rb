class ProductStockBook < ActiveRecord::Base
  #belongs_to :product_master, foreign_key: "product_master_id"
  validates :list_barcode, :stock_date,  presence: true
  validates_uniqueness_of :stock_date, :scope => :list_barcode, :message => "There is already an entry for Date for the Product!" 

  def productinfo
  	if self.list_barcode.present?
  		product = ProductList.where(list_barcode: self.list_barcode)
	  	if product.present?
	  		product.first.name + " (" + self.list_barcode + ")"
	  	else
	  		"<span style=color:violet;font-weight: normal; font-size:11px;>No barcode found in Product (Sell) List </span>"
	  	end
  	else
  		"<span style=color:violet;font-weight: normal; font-size:11px;>No barcode found in Product stock </span>"
  	end
  	
     
   end
end
