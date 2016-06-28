class ProductStock < ActiveRecord::Base
  #validates :ext_prod_code ,  :presence => { :message => "Please select product from list above!" }
  validates :barcode ,  :presence => { :message => "Please select product from list!" }
  #validates :current_stock, numericality: { only_integer: true },  :presence => { :message => "Please add no of pieces!" }
  validates :checked_date,  :presence => { :message => "Please select a date!" }
 validates_uniqueness_of :barcode, :scope => [:product_master_id, :checked_date], :message => "Not Saved, you have already created an opeing stock for date! "

  #belongs_to :product_master, foreign_key: "product_master_id"
  def productinfo
  	if self.barcode.present?
  		product = ProductList.where(list_barcode: self.barcode)
	  	if product.present?
	  		product.first.name + " (" + self.barcode + ")"
	  	else
	  		"No barcode found in Product (Sell) List"
	  	end
  	else
  		"No barcode found in Product stock"
  	end


   end
end
