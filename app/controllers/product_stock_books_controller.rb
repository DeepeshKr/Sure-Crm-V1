class ProductStockBooksController < ApplicationController
    before_action { protect_controllers_specific(4) } 
  before_action :set_product_stock_book, only: [:show, :edit, :update, :destroy]
  before_action :get_variables, only: [:index, :show, :edit, :update, :destroy]
  before_action :dropdowns, only: [:index, :edit, :update]
  # GET /product_stock_books
  # GET /product_stock_books.json
  def index
     @prev_datelist = Date.today.in_time_zone
     @or_from_date = Date.today #.in_time_zone - 30.days
     @or_to_date =  Date.today #.in_time_zone
    #@prev_datelist = "last checked for " + (Date.today - 1.day).strftime('%d-%b-%y')
    if params[:list_barcode].present? && params[:from_date].present? && params[:to_date].present?
      @show_add_update = 1
      #posting params
      @prod = params[:prod]
      @or_from_date = params[:from_date]
      @or_to_date = params[:to_date]
      #Date.strptime(params[:for_date], "%Y-%m-%d")
      from_date =  Date.strptime(@or_from_date, "%Y-%m-%d") if @or_from_date.present?
      to_date =  Date.strptime(@or_to_date, "%Y-%m-%d") if @or_to_date.present? 

      @datelist ||= []
      (from_date..to_date).each do |day|
        @datelist <<  day.strftime('%d-%b-%y')
      end

       if ProductList.where(extproductcode: @prod).present?
          @product_name = ProductList.where(extproductcode: @prod).first.productinfo
        end
        @from_date_text = from_date.strftime('%d-%b-%y')
        @to_date_text = to_date.strftime('%d-%b-%y')
          @product_stock_books = ProductStockBook.where(ext_prod_code: @prod)
          .where("TRUNC(stock_date) >= ? AND TRUNC(stock_date) <= ?", from_date, to_date)
          .order("stock_date")
         
          respond_to do |format|
            format.html
            format.csv do
              headers['Content-Disposition'] = "attachment; filename=\"stock-book\""
              headers['Content-Type'] ||= 'text/csv'
            end
          end
      
    else
      @show_add_update = 0
    end
   # @product_stock_books = ProductStockBook.all.limit(100)
   
  end

  # GET /product_stock_books/1
  # GET /product_stock_books/1.json
  # params prod from_date to_date
  #http://localhost:3000/stockbook?utf8=%E2%9C%93&prod=TOTS&from_date=04%2F01%2F2015&to_date=04%2F02%2F2015
  def show
    
  end

  # GET /product_stock_books/new
  def new
    @product_stock_book = ProductStockBook.new

  end

  # GET /product_stock_books/1/edit
  def edit
  end

  # POST /product_stock_books
  # POST /product_stock_books.json
  def create
    if params[:prod].present? && params[:from_date].present? && params[:to_date].present?
      prod = params[:prod]

      from_date =  Date.strptime(params[:from_date], "%m/%d/%Y") if params[:from_date].present?
      to_date =  Date.strptime(params[:to_date], "%m/%d/%Y") if params[:to_date].present? 

      #@datelist ||= []
      (from_date..to_date).each do |day|
       # @datelist <<  day.strftime('%d - %m - %y')
        create_update(day, prod)
      end
      #http://localhost:3000/stockbook?from_date=04%2F01%2F2015&prod=TOTS&to_date=04%2F02%2F2015
      redirect_to stockbook_path(from_date: params[:from_date],prod: prod, to_date: params[:to_date])
      #@product_stock_book = ProductStockBook.new(product_stock_book_params)

     #  respond_to do |format|
     #    if @product_stock_book.save
     #      format.html { redirect_to @product_stock_book, notice: 'Product stock book was successfully created.' }
     #      format.json { render :show, status: :created, location: @product_stock_book }
     #    else
     #      format.html { render :new }
     #      format.json { render json: @product_stock_book.errors, status: :unprocessable_entity }
     #    end
     # end
  end
end

  # PATCH/PUT /product_stock_books/1
  # PATCH/PUT /product_stock_books/1.json
  def update
    respond_to do |format|
      if @product_stock_book.update(product_stock_book_params)
        format.html { redirect_to @product_stock_book, notice: 'Product stock book was successfully updated.' }
        format.json { render :show, status: :ok, location: @product_stock_book }
      else
        format.html { render :edit }
        format.json { render json: @product_stock_book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_stock_books/1
  # DELETE /product_stock_books/1.json
  def destroy
    if params[:prod].present? && params[:from_date].present? && params[:to_date].present?
    
      @product_stock_book.destroy
      # respond_to do |format|
      #   format.html { redirect_to product_stock_books_url, notice: 'Product stock book was successfully destroyed.' }
      #   format.json { head :no_content }
      # end
      redirect_to stockbook_path(from_date: from_date,prod: prod, to_date: to_date)
    end
  end

  private
 
    # Use callbacks to share common setup or constraints between actions.
    def set_product_stock_book
      @product_stock_book = ProductStockBook.find(params[:id])
    end
    def dropdowns
      @productmasterlist = ProductList.all.where(list_barcode: ProductList.all.select(:list_barcode).distinct).order("name, list_barcode")
    end
    def get_variables
      @empcode = current_user.employee_code
      @empid = Employee.where(employeecode: @empcode).first.id
      @productmaster_id = params[:productmaster_id]
      @from_date = params[:from_date]
      @to_date = params[:to_date]
    end

    #create row for prod for each date
    def create_update(for_date, prod)
      @closing_qty = 0
      @closing_value = 0

       
      #check if product listing found for date
        if (ProductStockBook.where("TRUNC(stock_date) = ?", for_date).where(ext_prod_code: prod)).present?
          @product_stock_book = ProductStockBook.where("TRUNC(stock_date) = ?", for_date).where(ext_prod_code: prod).last
          #this is the first closing quantity step where 
          #as per table the closing 
          #@closing_qty = @product_stock_book.opening_qty
          else
          @product_stock_book = ProductStockBook.new(stock_date: for_date, :ext_prod_code => prod)
          @product_stock_book.save

            #update or create product info if creating the record for the first time
            if ProductMaster.where(extproductcode: prod).present?
              @product_stock_book.update(product_master_id: ProductMaster.where(extproductcode: prod).first.id)
              @product_stock_book.update(name: ProductMaster.where(extproductcode: prod).first.name)
            end

            if ProductList.where(extproductcode: prod).present?
              @product_stock_book.update(product_list_id: ProductList.where(extproductcode: prod).first.id)
            end
          
        end

         #opening stock - default to ZERO
        @product_stock_book.update(opening_qty: 0)
        @product_stock_book.update(opening_rate: 0)
        @product_stock_book.update(opening_value: 0)
           #get stock from previous stock date if available
        #using the stock book select the previous date and use the value for opeing stock fo today
        
        @old_product_stocks = ProductStockBook.where(ext_prod_code: prod).where("TRUNC(stock_date) < ?", for_date)
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
      @product_stock_adjusts = ProductStockAdjust.where(ext_prod_code: prod).where("TRUNC(created_date) = ? ", for_date)
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_stock_book_params
      params.require(:product_stock_book).permit(:stock_date, :product_master_id, 
        :product_list_id, :ext_prod_code, 
        :name, :opening_qty, :opening_rate, :opening_value, :purchased_qty, 
        :purchased_rate, :purchased_value, :returned_retail_qty, 
        :returned_retail_rate, :returned_retail_value, 
        :returned_wholesale_qty, :returned_wholesale_rate, 
        :returned_wholesale_value, :returned_others_qty, 
        :returned_others_rate, :returned_others_value, 
        :sold_retail_qty, :sold_retail_rate, :sold_retail_value, 
        :sold_wholesale, :sold_wholesale_rate, :sold_wholesale_value, 
        :sold_branch_qty, :sold_branch_rate, :sold_branch_value, 
        :corrections_qty, :corrections_rate, :corrections_value, 
        :closing_qty, :closing_rate, :closing_value, :list_barcode)
    end

end
