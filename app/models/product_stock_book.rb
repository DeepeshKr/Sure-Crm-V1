class ProductStockBook < ActiveRecord::Base
   attr_accessor :total_purchased_qty, :total_purchased_value, :total_returned_retail_qty, :total_returned_retail_value,   :total_returned_wholesale_qty, :total_returned_wholesale_value, :total_returned_others_qty, :total_returned_others_value, 
   :total_sold_retail_qty, :total_sold_wholesale, :total_sold_wholesale_value, :total_sold_branch_qty, :total_sold_branch_value, :total_corrections_qty, :total_corrections_value, :from_date, :to_date
  #belongs_to :product_master, foreign_key: "product_master_id"
  validates :list_barcode, :stock_date,  presence: true
  validates_uniqueness_of :stock_date, :scope => :list_barcode, :message => "There is already an entry for Date for the Product!" 
  
  
  def stock_book_summary from_date, to_date
    from_date =  Date.strptime(from_date, "%Y-%m-%d") if from_date.present?
    to_date =  Date.strptime(to_date, "%Y-%m-%d") if to_date.present?
    
    total_all_products = []  
    all_products = ProductStockBook.where("TRUNC(stock_date) >= ? AND TRUNC(stock_date) <= ?", from_date, to_date) #.distinct(:list_barcode) # .where( @barcode)
  
    all_products.each do |product|
      product_stock_book = ProductStockBook.new 
      product_stock_book.name = product.productinfo
      product_stock_book.ext_prod_code = product.ext_prod_code
      product_stock_book.list_barcode = product.list_barcode
      product_stock_book.from_date = from_date
      product_stock_book.to_date = to_date
      product_stock_book.total_purchased_qty = all_products.where(list_barcode: product.list_barcode).sum(:purchased_qty) || 0.0
      product_stock_book.total_purchased_value = all_products.where(list_barcode: product.list_barcode).sum(:purchased_value) || 0.0
      product_stock_book.total_returned_retail_qty = all_products.where(list_barcode: product.list_barcode).sum(:returned_retail_qty) || 0.0
      product_stock_book.total_returned_retail_value = all_products.where(list_barcode: product.list_barcode).sum(:returned_retail_value) || 0.0
      product_stock_book.total_returned_wholesale_qty = all_products.where(list_barcode: product.list_barcode).sum(:returned_wholesale_qty) || 0.0
      product_stock_book.total_returned_wholesale_value = all_products.where(list_barcode: product.list_barcode).sum(:returned_wholesale_value) || 0.0
      product_stock_book.total_returned_others_qty = all_products.where(list_barcode: product.list_barcode).sum(:returned_others_qty) || 0.0
      product_stock_book.total_returned_others_value = all_products.where(list_barcode: product.list_barcode).sum(:returned_others_value) || 0.0
      product_stock_book.total_sold_retail_qty = all_products.where(list_barcode: product.list_barcode).sum(:sold_retail_qty) || 0.0
      product_stock_book.total_sold_wholesale = all_products.where(list_barcode: product.list_barcode).sum(:sold_wholesale) || 0.0
      product_stock_book.total_sold_wholesale_value = all_products.where(list_barcode: product.list_barcode).sum(:sold_wholesale_value) || 0.0
      product_stock_book.total_sold_branch_qty = all_products.where(list_barcode: product.list_barcode).sum(:sold_branch_qt) || 0.0
      product_stock_book.total_sold_branch_value = all_products.where(list_barcode: product.list_barcode).sum(:sold_branch_value) || 0.0
      product_stock_book.total_corrections_qty = all_products.where(list_barcode: product.list_barcode).sum(:corrections_qty) || 0.0
      product_stock_book.total_corrections_value = all_products.where(list_barcode: product.list_barcode).sum(:corrections_value) || 0.0
    
      total_all_products << product_stock_book
    end  
  
    return total_all_products
  end
  
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
