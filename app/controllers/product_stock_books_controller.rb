class ProductStockBooksController < ApplicationController

   include StockBook
   before_action { protect_controllers_specific(4) }
   before_action :set_product_stock_book, only: [:show, :edit, :update, :destroy]
   before_action :get_variables, only: [:index, :show, :edit, :update, :destroy]
   before_action :dropdowns, only: [:index, :edit, :update]
  # GET /product_stock_books
  # GET /product_stock_books.json
  def index
    @show
    @retail_sales_qty = 0
    @retail_sales_val = 0
    @retail_returns_qty = 0
    @retail_returns_val = 0
    @wholesale_sale_qty = 0
    @wholesale_sale_val = 0
    @wholesale_returns_qty = 0
    @wholesale_returns_val = 0
    @other_returns_val = 0
    @other_returns_qty = 0
    @branch_sales_qty = 0
    @branch_sales_val = 0
    @branch_returns_qty = 0
    @branch_returns_val = 0
    @opening_val = 0
    @opening_qty = 0
    @purchased_val = 0
    @purchased_qty = 0
    @corrections_qty = 0
    @corrections_val = 0
    @closing_qty = 0
    @closing_val = 0



     @prev_datelist = Date.today.in_time_zone
     @or_from_date = Date.today #.in_time_zone - 30.days
     @or_to_date =  Date.today #.in_time_zone
    #@prev_datelist = "last checked for " + (Date.today - 1.day).strftime('%d-%b-%y')
    if params[:barcode].present? && params[:from_date].present? && params[:to_date].present?
      @show_add_update = 1
      #posting params
      @barcode = params[:barcode]
      @prod = ProductList.where(list_barcode: params[:barcode]).pluck(:extproductcode)
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
          @product_stock_books = ProductStockBook.where(list_barcode: @barcode)
          .where("TRUNC(stock_date) >= ? AND TRUNC(stock_date) <= ?", from_date, to_date)
          .order("stock_date")
          file_name = "stock_book_#{@from_date_text}_#{@to_date_text}.csv"
          respond_to do |format|
            format.html
            format.csv do
              headers['Content-Disposition'] = "attachment; filename=\"#{file_name}\""
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
    @barcode = @product_stock_book.list_barcode
     @prod = ProductList.where(list_barcode: @product_stock_book.list_barcode).pluck(:extproductcode)
    @old_product_stocks = ProductStockBook.where(:list_barcode => @product_stock_book.list_barcode)
        .where("TRUNC(stock_date) < ?", @product_stock_book.stock_date)
      if @old_product_stocks.present?

        @old_product_stock = @old_product_stocks.order("stock_date DESC").first
        if (@old_product_stock.stock_date.month != 3 && @old_product_stock.stock_date.day != 31)
         @prev_closing_stock =  @old_product_stock.closing_qty

         @prev_date = @old_product_stock.stock_date
        else
           @prev_closing_stock = 0
            @prev_date = "Not Applicable"
       end

      end

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
    if params[:barcode].present? && params[:from_date].present? && params[:to_date].present?
      barcode = params[:barcode]

      from_date =  Date.strptime(params[:from_date], "%Y-%m-%d") if params[:from_date].present?
      to_date =  Date.strptime(params[:to_date], "%Y-%m-%d") if params[:to_date].present?

      #@datelist ||= []
      (from_date..to_date).each do |day|
       # @datelist <<  day.strftime('%d - %m - %y')
        create_stock_book(day, barcode)
      end
      #barcode = ProductList.where(extproductcode: prod).first.list_barcode
      #http://localhost:3000/stockbook?from_date=04%2F01%2F2015&prod=TOTS&to_date=04%2F02%2F2015
      redirect_to stockbook_path(barcode: barcode,from_date: params[:from_date], to_date: params[:to_date])
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

def stockbook_details
@route_details = "Nothing selected"
  if params.has_key?(:route)
    @from_date = Date.strptime(params[:from_date], "%Y-%m-%d")
    @prod_list = ProductList.where(list_barcode: params[:barcode]).pluck(:extproductcode)

    case @route = params[:route]# a_variable is the variable we want to compare
      #opening_stock
      when @route = "opening_stock"
        @route_details = "Opening stock on #{@from_date}"

      #stock_journal
      when @route = "stock_journal"
        @route_details = "Stock Journal for #{@from_date}"
       #stock_purchased
      when @route = "stock_purchased"
        @route_details = "Stock Purchased on #{@from_date}"
        @purchases_new = PURCHASES_NEW.where(prod: @prod_list).where("TRUNC(rdate) = ?", @from_date)


      #sold_retail
      when @route = "sold_retail"
        @route_details = "Sold over Retail #{@from_date}"
        @vpp = VPP.where(prod: @prod_list).where("TRUNC(shdate) = ?", @from_date).where("CFO != 'Y' OR CFO IS NULL") #.where("CFO <> 'Y' or CFO = NOTHING")
        if @vpp.present?
          #Retail Sales
          #total
          @retailsalestotal = @vpp.sum(:paidamt)
          #pieces
          @retailsalespieces = @vpp.sum(:quantity)
        end
      #sold_wholesale
      when @route = "sold_wholesale"
        @route_details = "Sold over Wholesale"
        @newwlsdet = NEWWLSDET.where(prod: @prod_list).where("TRUNC(shdate) = ? ", @from_date) #.where("CFO != 'Y' OR CFO IS NULL")


      #sold_branch at retails counters
      when @route = "sold_branch"
        @route_details = "Sold over Branch"
        @tempinv_newwlsdet = CASHSALE.where(prod: @prod_list)
        .where("TRUNC(paiddate) = ?", @from_date) #.where("CFO != 'Y' OR CFO IS NULL")


      #returned_retail
      when @route = "returned_retail"
        @route_details = "Returned by Retail"
        @vpp = VPP.where(prod: @prod_list).where("TRUNC(returndate) = ?", @from_date)#.where("CFO = 'Y'") #.where("CFO <> 'Y' or CFO = NOTHING")
        if @vpp.present?
          #Retail Sales
          #total
          @retailsalestotal = @vpp.sum(:invoiceamount)
          #pieces
          @retailsalespieces = @vpp.sum(:quantity)
        end

      #returned_wholesale
      when @route = "returned_wholesale"
        @route_details = "Returned by wholesale - check"

         #Returned whole sales
       @new_depts = NEW_DEPT.where(prod: @prod_list).where("TRUNC(rdate) = ?", @from_date).where(type: 'WLS')
       # @newwlsdet = NEWWLSDET.where(prod: prod).where("TRUNC(shdate) >= ? and TRUNC(shdate) <= ?", from_date, to_date).where("CFO != 'Y'")
        #@new_depts = NEW_DEPT.where(prod: @prod_list).where(type: 'WLS').limit(10)
        if @new_depts.present?

           @route_details = "Returned by wholesale - check found #{@new_depts.count}"
        end

      #returned_branch
      when @route = "returned_branch"
        @route_details = "Returned by branch selected"


      else
        @route_details = "Nothing selected #{route}"
    end
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
      @productlist = ProductList.all.where(list_barcode: ProductList.all.select(:list_barcode).distinct).order("name, list_barcode")
    end
    def get_variables
      @empcode = current_user.employee_code
      @empid = Employee.where(employeecode: @empcode).first.id
      @productmaster_id = params[:productmaster_id]
      @from_date = params[:from_date]
      @to_date = params[:to_date]
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
