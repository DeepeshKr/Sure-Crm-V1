module StockBook
	#create row for prod for each date
    def create_stock_book(for_date, barcode)
      @closing_qty = 0
      @closing_value = 0

      prod = ProductList.where(list_barcode: barcode).pluck(:extproductcode) 
      #check if product listing found for date
        if (ProductStockBook.where("TRUNC(stock_date) = ?", for_date)
          .where(list_barcode: barcode)).present?
          @product_stock_book = ProductStockBook.where("TRUNC(stock_date) = ?", for_date)
          .where(list_barcode: barcode).last
          #this is the first closing quantity step where 
          #as per table the closing 
          #@closing_qty = @product_stock_book.opening_qty
          else
          @product_stock_book = ProductStockBook.new(stock_date: for_date, 
             :list_barcode => barcode)
          #:ext_prod_code => prod.first,
          @product_stock_book.save

            # #update or create product info if creating the record for the first time
            # if ProductMaster.where(extproductcode: prod).present?
            #   #@product_stock_book.update(product_master_id: ProductMaster.where(extproductcode: prod).first.id)
              
            # end

            if ProductList.where(list_barcode: barcode).present?
              @product_stock_book.update(product_list_id: ProductList
                .where(list_barcode: barcode).first.id)
              @product_stock_book.update(name: ProductList
                .where(list_barcode: barcode).first.name)
              @product_stock_book.update(product_master_id: ProductList
                .where(list_barcode: barcode).first.product_master_id)
            end
          
        end

         #opening stock - default to ZERO
        @product_stock_book.update(opening_qty: 0)
        @product_stock_book.update(opening_rate: 0)
        @product_stock_book.update(opening_value: 0)
           #get stock from previous stock date if available
        #using the stock book select the previous date and use the value for opeing stock fo today
        
        @old_product_stocks = ProductStockBook.where(:list_barcode => barcode)
        .where("TRUNC(stock_date) < ?", for_date)
      if @old_product_stocks.present?

        @old_product_stock = @old_product_stocks.order("stock_date DESC").first
        if (@old_product_stock.stock_date.month != 3 && @old_product_stock.stock_date.day != 31)
          @product_stock_book.update(opening_qty: @old_product_stock.closing_qty)
          @product_stock_book.update(opening_rate: @old_product_stock.closing_rate)
          @product_stock_book.update(opening_value: @old_product_stock.closing_value)

          #update closing stock calculation if there is any value present
          @closing_qty += (@old_product_stock.closing_qty || 0 if  @old_product_stock.closing_qty.present?)
       end

      end
         
      # section to add update opening stock 
      # this value is manually entered
      @product_stocks = ProductStock.where(ext_prod_code: prod).where("TRUNC(checked_date) = ?", for_date)
      if @product_stocks.present?
        #code
        @product_stock_book.update(opening_qty: @product_stocks.sum(:current_stock))
        @product_stock_book.update(opening_rate: 0)
        @product_stock_book.update(opening_value: 0)

        #update closing
        past_product_stock =  (@product_stocks.sum(:current_stock) || 0 if  @product_stocks.sum(:current_stock).present?)
        @closing_qty += past_product_stock
        @closing_value += 0

     end
     
   


        #Purchased
        @purchases_new = PURCHASES_NEW.where(prod: prod).where("TRUNC(rdate) = ?", for_date)
        if @purchases_new.present?
          #Purchases        
          @product_stock_book.update(purchased_qty: @purchases_new.sum(:qty))
          @product_stock_book.update(purchased_rate: 0)
          @product_stock_book.update(purchased_value: @purchases_new.sum(:invamt))

           #update closing
          @closing_qty += @purchases_new.sum(:qty)
          @closing_value += @purchases_new.sum(:invamt)

        else
          @product_stock_book.update(purchased_qty: 0)
          @product_stock_book.update(purchased_rate: 0)
          @product_stock_book.update(purchased_value: 0)
        end

      #Returned Retail
      @returned_vpp = VPP.where(prod: prod).where("TRUNC(returndate) = ?", for_date).where("CFO != 'Y'")
      if @returned_vpp.present?
          @product_stock_book.update(returned_retail_qty: @returned_vpp.sum(:quantity))
          @product_stock_book.update(returned_retail_rate: 0)
          @product_stock_book.update(returned_retail_value: @returned_vpp.sum(:invoiceamount))
            #update closing
          @closing_qty += (@returned_vpp.sum(:quantity) || 0 if  @returned_vpp.sum(:quantity) > 0)
            # return_vpp_qty = @returned_vpp.sum(:quantity) if @returned_vpp.sum(:quantity) > 0
            # if return_vpp_qty.present? && return_vpp_qty > 0 
            #   @closing_qty += return_vpp_qty
            # end
          @closing_value += (@returned_vpp.sum(:invoiceamount) || 0 if  @returned_vpp.sum(:invoiceamount) > 0)
          # return_vpp_val =  @returned_vpp.sum(:invoiceamount) if @returned_vpp.sum(:invoiceamount) > 0
          # if return_vpp_val.present? && return_vpp_val > 0
          #     @closing_value += return_vpp_val
          # end       
      
        else
          @product_stock_book.update(returned_retail_qty: 0)
          @product_stock_book.update(returned_retail_rate: 0)
          @product_stock_book.update(returned_retail_value: 0)
      end

       #Returned whole sales
       @new_dept = NEW_DEPT.where(prod: prod).where("TRUNC(rdate) = ?", for_date) #.where("CFO != 'Y'")
      if @new_dept.present?
          @product_stock_book.update(returned_wholesale_qty: @new_dept.sum(:qty))
          @product_stock_book.update(returned_wholesale_rate: 0)
          @product_stock_book.update(returned_wholesale_value: 0)
            #update closing
          @closing_qty += (@new_dept.sum(:qty) || 0 if  @new_dept.sum(:qty) > 0)
          
          #   return_vpp_qty = @returned_vpp.sum(:quantity) if @returned_vpp.sum(:quantity) > 0
          #   if return_vpp_qty.present? && return_vpp_qty > 0 
          #     @closing_qty += return_vpp_qty
          #   end
          # return_vpp_val =  @returned_vpp.sum(:invoiceamount) if @returned_vpp.sum(:invoiceamount) > 0
          # if return_vpp_val.present? && return_vpp_val > 0
          #     @closing_value += return_vpp_val
          # end       
      
        else
          @product_stock_book.update(returned_wholesale_qty: 0)
          @product_stock_book.update(returned_wholesale_rate: 0)
          @product_stock_book.update(returned_wholesale_value: 0)
      end

      #Sold Retail
      @sold_vpp = VPP.where(prod: prod).where("TRUNC(shdate) = ?", for_date)
      .where("CFO != 'Y' OR CFO IS NULL")
      #.where("CFO != 'Y'")
      if @sold_vpp.present?
          @product_stock_book.update(sold_retail_qty: @sold_vpp.sum(:quantity))
          @product_stock_book.update(sold_retail_rate: 0)
          @product_stock_book.update(sold_retail_value: @sold_vpp.sum(:invoiceamount))
         
         #update closing
        @closing_qty -= @sold_vpp.sum(:quantity)
        @closing_value -= @sold_vpp.sum(:invoiceamount)
        else
           @product_stock_book.update(sold_retail_qty: 0)
          @product_stock_book.update(sold_retail_rate: 0)
          @product_stock_book.update(sold_retail_value: 0)
      end

      #Sold wholesale
      @newwlsdet = NEWWLSDET.where(prod: prod).where("TRUNC(shdate) = ? ", for_date)
      .where("CFO != 'Y' OR CFO IS NULL")
      if @newwlsdet.present?
        ##wholesale Sales
        @product_stock_book.update(sold_wholesale: @newwlsdet.sum(:quantity))
        @product_stock_book.update(sold_wholesale_rate: 0)
        @product_stock_book.update(sold_wholesale_value: @newwlsdet.sum(:totamt))

         #update closing
        @closing_qty -= @newwlsdet.sum(:quantity)
        @closing_value -= @newwlsdet.sum(:totamt)
      else
        @product_stock_book.update(sold_wholesale: 0)
        @product_stock_book.update(sold_wholesale_rate: 0)
        @product_stock_book.update(sold_wholesale_value: 0)
      end

      #Sold Branch
      @tempinv_newwlsdet = TEMPINV_NEWWLSDET.where(prod: prod).where("TRUNC(shdate) = ?", for_date).where("CFO != 'Y'")
      if @tempinv_newwlsdet.present?
        ##Branch Sales
        
        @product_stock_book.update(sold_branch_qty: @tempinv_newwlsdet.sum(:quantity))
        @product_stock_book.update(sold_branch_rate: 0)
        @product_stock_book.update(sold_branch_value: @tempinv_newwlsdet.sum(:totamt))

        #update closing
        @closing_qty -= @tempinv_newwlsdet.sum(:quantity)
        @closing_value -= @tempinv_newwlsdet.sum(:totamt)
      else
        @product_stock_book.update(sold_branch_qty: 0)
        @product_stock_book.update(sold_branch_rate: 0)
        @product_stock_book.update(sold_branch_value: 0)
      end

      #Stock Corrections
      @product_stock_adjusts = ProductStockAdjust.where(ext_prod_code: prod)
      .where("TRUNC(created_date) = ? ", for_date)
      if @product_stock_adjusts.present?
        #code
        @product_stock_book.update(corrections_qty: @product_stock_adjusts.sum(:change_stock))
        @product_stock_book.update(corrections_rate: 0)
        @product_stock_book.update(corrections_value: @product_stock_adjusts.sum(:total))

        #update closing
        @closing_qty += @product_stock_adjusts.sum(:change_stock)
        @closing_value += @product_stock_adjusts.sum(:total)

      else
        @product_stock_book.update(corrections_qty: 0)
        @product_stock_book.update(corrections_rate: 0)
        @product_stock_book.update(corrections_value: 0)
      end
      #@product_stock_book.stock_date
     
     # @product_stock_book.ext_prod_code    
      
      @product_stock_book.update(returned_others_qty: 0)
      @product_stock_book.update(returned_others_rate: 0)
      @product_stock_book.update(returned_others_value: 0)
           
      @product_stock_book.update(closing_qty: @closing_qty)
      @product_stock_book.update(closing_rate: 0)
      @product_stock_book.update(closing_value: @closing_value)
    end
end