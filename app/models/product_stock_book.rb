class ProductStockBook < ActiveRecord::Base
   attr_accessor :total_purchased_qty, :total_purchased_value, :total_returned_retail_qty, :total_returned_retail_value,   :total_returned_wholesale_qty, :total_returned_wholesale_value, :total_returned_others_qty, :total_returned_others_value,
   :total_sold_retail_qty, :total_sold_retail_value, :total_sold_wholesale, :total_sold_wholesale_value, :total_sold_branch_qty, :total_sold_branch_value, :total_corrections_qty, :total_corrections_value, :from_date, :to_date
  #belongs_to :product_master, foreign_key: "product_master_id"
  validates :list_barcode, :stock_date,  presence: true
  validates_uniqueness_of :stock_date, :scope => :list_barcode, :message => "There is already an entry for Date for the Product!"


  def stock_book_summary from_date, to_date, show_all

    total_all_products = []
    
    product_stock = ProductStockBook.where("TRUNC(stock_date) >= ? AND TRUNC(stock_date) <= ?", from_date, to_date).distinct.pluck(:list_barcode) #.order(:productinfo) # # .where( @barcode)
  all_products = ProductStockBook.where("TRUNC(stock_date) >= ? AND TRUNC(stock_date) <= ?", from_date, to_date).order("total_purchased_qty, total_returned_retail_qty, total_returned_wholesale_qty,  total_returned_others_qty, total_sold_retail_qty, total_sold_wholesale, total_sold_branch_qty,  total_corrections_qty DESC")

  # .order("total_purchased_qty, total_purchased_value, total_returned_retail_qty, total_returned_retail_value, total_returned_wholesale_qty, total_returned_wholesale_value, total_returned_others_qty, total_returned_others_value, total_sold_retail_qty, total_sold_retail_value, total_sold_wholesale, total_sold_wholesale_value, total_sold_branch_qty, total_sold_branch_value, total_corrections_qty, total_corrections_value DESC")

    product_stock.each do |product|
      product_stock_book = ProductStockBook.new
      product_stock_book.name = ProductStockBook.find_by_list_barcode(product).productinfo  #product.productinfo
      product_stock_book.ext_prod_code = ProductStockBook.find_by_list_barcode(product).ext_prod_code
      product_stock_book.list_barcode = product
      product_stock_book.from_date = from_date
      product_stock_book.to_date = to_date
      product_stock_book.total_purchased_qty = 0
      product_stock_book.total_purchased_value = 0
      product_stock_book.total_returned_retail_qty = 0
      product_stock_book.total_returned_retail_value = 0
      product_stock_book.total_returned_wholesale_qty = 0
      product_stock_book.total_returned_wholesale_value = 0
      product_stock_book.total_returned_others_qty = 0
      product_stock_book.total_returned_others_value = 0
      product_stock_book.total_sold_retail_qty = 0
      product_stock_book.total_sold_retail_value = 0
      product_stock_book.total_sold_wholesale = 0
      product_stock_book.total_sold_wholesale_value = 0
      product_stock_book.total_sold_branch_qty = 0
      product_stock_book.total_sold_branch_value = 0
      product_stock_book.total_corrections_qty = 0
      product_stock_book.total_corrections_value = 0
 #

      product_stock_book.total_purchased_qty = all_products.where(list_barcode: product).sum(:purchased_qty) || 0.0
      product_stock_book.total_purchased_value = all_products.where(list_barcode: product).sum(:purchased_value) || 0.0
      product_stock_book.total_returned_retail_qty = all_products.where(list_barcode: product).sum(:returned_retail_qty) || 0.0
      product_stock_book.total_returned_retail_value = all_products.where(list_barcode: product).sum(:returned_retail_value) || 0.0
      product_stock_book.total_returned_wholesale_qty = all_products.where(list_barcode: product).sum(:returned_wholesale_qty) || 0.0
      product_stock_book.total_returned_wholesale_value = all_products.where(list_barcode: product).sum(:returned_wholesale_value) || 0.0
      product_stock_book.total_returned_others_qty = all_products.where(list_barcode: product).sum(:returned_others_qty) || 0.0
      product_stock_book.total_returned_others_value = all_products.where(list_barcode: product).sum(:returned_others_value) || 0.0
      product_stock_book.total_sold_retail_qty = all_products.where(list_barcode: product).sum(:sold_retail_qty) || 0.0
      product_stock_book.total_sold_retail_value = all_products.where(list_barcode: product).sum(:sold_retail_value) || 0.0
      product_stock_book.total_sold_wholesale = all_products.where(list_barcode: product).sum(:sold_wholesale) || 0.0
      product_stock_book.total_sold_wholesale_value = all_products.where(list_barcode: product).sum(:sold_wholesale_value) || 0.0
      product_stock_book.total_sold_branch_qty = all_products.where(list_barcode: product).sum(:sold_branch_qty) || 0.0
      product_stock_book.total_sold_branch_value = all_products.where(list_barcode: product).sum(:sold_branch_value) || 0.0
      product_stock_book.total_corrections_qty = all_products.where(list_barcode: product).sum(:corrections_qty) || 0.0
      product_stock_book.total_corrections_value = all_products.where(list_barcode: product).sum(:corrections_value) || 0.0

      if show_all==false
        if (product_stock_book.total_purchased_qty == 0 && product_stock_book.total_purchased_value == 0 && product_stock_book.total_returned_retail_qty == 0 && product_stock_book.total_returned_retail_value == 0 && product_stock_book.total_returned_wholesale_qty == 0 && product_stock_book.total_returned_wholesale_value == 0 && product_stock_book.total_returned_others_qty == 0 && product_stock_book.total_returned_others_value == 0 && product_stock_book.total_sold_retail_qty == 0 && product_stock_book.total_sold_retail_value == 0 && product_stock_book.total_sold_wholesale == 0 && product_stock_book.total_sold_wholesale_value == 0 && product_stock_book.total_sold_branch_qty == 0 && product_stock_book.total_sold_branch_value == 0 && product_stock_book.total_corrections_qty == 0 && product_stock_book.total_corrections_value  == 0)

            next
          else
         total_all_products << product_stock_book
        end
      else
       total_all_products << product_stock_book
     end


    end

    total_all_products= total_all_products.sort_by{|c| c[:name]}
    # total_all_products= total_all_products.sort_by{|c| [c[:total_purchased_qty], c[:total_purchased_value], c[:total_returned_retail_qty], c[:total_returned_retail_value], c[:total_returned_wholesale_qty], c[:total_returned_wholesale_value], c[:total_returned_others_qty], c[:total_returned_others_value], c[:total_sold_retail_qty], c[:total_sold_retail_value], c[:total_sold_wholesale], c[:total_sold_wholesale_value], c[:total_sold_branch_qty], c[:total_sold_branch_value], c[:total_corrections_qty], c[:total_corrections_value], c[:name]]}.reverse

    return total_all_products
  end

  def date_wise from_date, to_date, show_all

        total_all_products = []
        product_stock = ProductStockBook.where("TRUNC(stock_date) >= ? AND TRUNC(stock_date) <= ?", from_date, to_date).distinct.pluck(:list_barcode) #.order(:productinfo) # # .where( @barcode)
      all_products = ProductStockBook.where("TRUNC(stock_date) >= ? AND TRUNC(stock_date) <= ?", from_date, to_date).order("total_purchased_qty, total_returned_retail_qty, total_returned_wholesale_qty,  total_returned_others_qty, total_sold_retail_qty, total_sold_wholesale, total_sold_branch_qty,  total_corrections_qty DESC")

      # .order("total_purchased_qty, total_purchased_value, total_returned_retail_qty, total_returned_retail_value, total_returned_wholesale_qty, total_returned_wholesale_value, total_returned_others_qty, total_returned_others_value, total_sold_retail_qty, total_sold_retail_value, total_sold_wholesale, total_sold_wholesale_value, total_sold_branch_qty, total_sold_branch_value, total_corrections_qty, total_corrections_value DESC")

        product_stock.each do |product|
          product_stock_book = ProductStockBook.new
          product_stock_book.name = ProductStockBook.find_by_list_barcode(product).productinfo  #product.productinfo
          product_stock_book.ext_prod_code = ProductStockBook.find_by_list_barcode(product).ext_prod_code
          product_stock_book.list_barcode = product
          product_stock_book.from_date = from_date
          product_stock_book.to_date = to_date
          product_stock_book.total_purchased_qty = 0
          product_stock_book.total_purchased_value = 0
          product_stock_book.total_returned_retail_qty = 0
          product_stock_book.total_returned_retail_value = 0
          product_stock_book.total_returned_wholesale_qty = 0
          product_stock_book.total_returned_wholesale_value = 0
          product_stock_book.total_returned_others_qty = 0
          product_stock_book.total_returned_others_value = 0
          product_stock_book.total_sold_retail_qty = 0
          product_stock_book.total_sold_retail_value = 0
          product_stock_book.total_sold_wholesale = 0
          product_stock_book.total_sold_wholesale_value = 0
          product_stock_book.total_sold_branch_qty = 0
          product_stock_book.total_sold_branch_value = 0
          product_stock_book.total_corrections_qty = 0
          product_stock_book.total_corrections_value = 0
     #

          product_stock_book.total_purchased_qty = all_products.where(list_barcode: product).sum(:purchased_qty) || 0.0
          product_stock_book.total_purchased_value = all_products.where(list_barcode: product).sum(:purchased_value) || 0.0
          product_stock_book.total_returned_retail_qty = all_products.where(list_barcode: product).sum(:returned_retail_qty) || 0.0
          product_stock_book.total_returned_retail_value = all_products.where(list_barcode: product).sum(:returned_retail_value) || 0.0
          product_stock_book.total_returned_wholesale_qty = all_products.where(list_barcode: product).sum(:returned_wholesale_qty) || 0.0
          product_stock_book.total_returned_wholesale_value = all_products.where(list_barcode: product).sum(:returned_wholesale_value) || 0.0
          product_stock_book.total_returned_others_qty = all_products.where(list_barcode: product).sum(:returned_others_qty) || 0.0
          product_stock_book.total_returned_others_value = all_products.where(list_barcode: product).sum(:returned_others_value) || 0.0
          product_stock_book.total_sold_retail_qty = all_products.where(list_barcode: product).sum(:sold_retail_qty) || 0.0
          product_stock_book.total_sold_retail_value = all_products.where(list_barcode: product).sum(:sold_retail_value) || 0.0
          product_stock_book.total_sold_wholesale = all_products.where(list_barcode: product).sum(:sold_wholesale) || 0.0
          product_stock_book.total_sold_wholesale_value = all_products.where(list_barcode: product).sum(:sold_wholesale_value) || 0.0
          product_stock_book.total_sold_branch_qty = all_products.where(list_barcode: product).sum(:sold_branch_qty) || 0.0
          product_stock_book.total_sold_branch_value = all_products.where(list_barcode: product).sum(:sold_branch_value) || 0.0
          product_stock_book.total_corrections_qty = all_products.where(list_barcode: product).sum(:corrections_qty) || 0.0
          product_stock_book.total_corrections_value = all_products.where(list_barcode: product).sum(:corrections_value) || 0.0

          if show_all==false
            if (product_stock_book.total_purchased_qty == 0 && product_stock_book.total_purchased_value == 0 && product_stock_book.total_returned_retail_qty == 0 && product_stock_book.total_returned_retail_value == 0 && product_stock_book.total_returned_wholesale_qty == 0 && product_stock_book.total_returned_wholesale_value == 0 && product_stock_book.total_returned_others_qty == 0 && product_stock_book.total_returned_others_value == 0 && product_stock_book.total_sold_retail_qty == 0 && product_stock_book.total_sold_retail_value == 0 && product_stock_book.total_sold_wholesale == 0 && product_stock_book.total_sold_wholesale_value == 0 && product_stock_book.total_sold_branch_qty == 0 && product_stock_book.total_sold_branch_value == 0 && product_stock_book.total_corrections_qty == 0 && product_stock_book.total_corrections_value  == 0)

                next
              else
             total_all_products << product_stock_book
            end
          else
           total_all_products << product_stock_book
         end


        end

       # total_all_products= total_all_products.sort_by{|c| c[:name]}
    
        return total_all_products
  end
  
  def productinfo
  	if self.list_barcode.present?
  		product = ProductList.where(list_barcode: self.list_barcode)
	  	if product.present?
	  		product.first.name + " (" + self.list_barcode + ")"
	  	else
	  		"No barcode found in Product (Sell) List: #{self.list_barcode}"
	  	end
  	else
  		"No barcode found"
  	end


   end
end
