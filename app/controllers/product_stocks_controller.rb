class ProductStocksController < ApplicationController
    before_action { protect_controllers_specific(4) } 
  before_action :set_product_stock, only: [:show, :edit, :update, :destroy]

  # GET /product_stocks
  # GET /product_stocks.json
  def index
    if params[:for_date].present?
      for_date =  Date.strptime(params[:for_date], "%m/%d/%Y")
      @product_stocks = ProductStock.where('TRUNC(checked_date) = ?',for_date)

       productmastlist = @product_stocks.pluck(:product_master_id)
        @product_stock = ProductStock.new(checked_date: for_date)
        @for_date_display = for_date.strftime("%d-%b-%Y")
        if productmastlist.present?
             @productmasterlist = ProductMaster.where('id NOT IN (?)', productmastlist).order("name, extproductcode")
            @productlistname = "Rest of the Products"

        else
             @productmasterlist = ProductMaster.all.order("name, extproductcode")
             @productlistname = "All Products (none found)"
        end
     

    else
      @for_date_display = "No Date selected showing Recently changed"
      @product_stocks = ProductStock.all.limit(50).order("updated_at DESC")
    end
    # 
    #removed link buttong
    #<%= link_to 'New Product stock', new_product_stock_path %>

  end

  # GET /product_stocks/1
  # GET /product_stocks/1.json
  def show
  end

  def showfordate
     @productstocklist ||= []
      @product_stocks = ProductStock.all
    if params[:for_date].present?
     # for_date =  Date.strptime(params[:for_date], "%m/%d/%Y")
    #  productmasterlist = ProductMaster.all
    # productmasterlist.each  do |p|
    #   if ProductStock.where(product_master_id: p.id).where(checked_date: for_date).present?
    #  product_stock = ProductStock.where(product_master_id: p.id).where(checked_date: for_date).first
    #   @productstocklist << {:stock_id => product_stock.id, , :prod => p.ext_prod_code,
    #         :product => p.name, :for_date =>  for_date,
    #       :nos => product_stock.current_stock  }
    #   else
    #     @productstocklist << {:product => p.name, :prod => p.ext_prod_code, :for_date =>  for_date,
    #       :nos => product_stock.current_stock  }
    #   end
    # else
    #   @showresults = "Please select a date to show / edit or add product stock"

    # end
     
   end
  end

  def updatefordate
    if params[:for_date].present?
      redirect_to showfordate(for_date: params[:for_date])
    end
  end

  # GET /product_stocks/new
  def new
    @product_stock = ProductStock.new
  end

  # GET /product_stocks/1/edit
  def edit
     # productmastlist = @product_stocks.pluck(:product_master_id)
        #@product_stock = ProductStock.new(checked_date: for_date)
        @for_date_display = @product_stock.checked_date.strftime("%d-%b-%Y")
               @productmasterlist = ProductMaster.where('id = ?', @product_stock.product_master_id).order("name, extproductcode")
            @productlistname = "Edit Stock for Products"     
  end

  # POST /product_stocks
  # POST /product_stocks.json
  def create
    @product_stock = ProductStock.new(product_stock_params)

    
    respond_to do |format|
      if @product_stock.save
        product_master = ProductMaster.find(@product_stock.product_master_id)
        @product_stock.update(ext_prod_code: product_master.extproductcode)
        # if params[:paid].present?   
        #   format.html { redirect_to productreport_path(prod: params[:prod], from_date: params[:from_date], to_date: params[:to_date], paid: params[:paid]), notice: 'Product Opening Stock was successfully created.' }
        # elsif if params[:prod].present? 
        #   format.html { redirect_to productreport_path(prod: params[:prod], from_date: params[:from_date], to_date: params[:to_date]), notice: 'Product Opening Stock was successfully created.' }
        # else
        # end

		  #redirect_to product_stocks_path(:for_date => @product_stock.checked_date)
      
        #redirect_to payment_path(:order_id => @order_master.id)
        format.html {  redirect_to product_stocks_url(:for_date => @product_stock.checked_date.strftime("%m/%d/%Y")), notice: 'Product Opening Stock was successfully created.' }
        format.json { render :show, status: :created, location: @product_stock }
      else
        format.html { render :new }
        format.json { render json: @product_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /product_stocks/1
  # PATCH/PUT /product_stocks/1.json
  def update
    respond_to do |format|
      if @product_stock.update(product_stock_params)
         product_master = ProductMaster.find(@product_stock.product_master_id)
        @product_stock.update(ext_prod_code: product_master.extproductcode)
       
        format.html { redirect_to product_stocks_url(:for_date => @product_stock.checked_date.strftime("%m/%d/%Y")), notice: 'Product Opening stock was successfully updated.' }
        format.json { render :show, status: :ok, location: @product_stock }
      else
        format.html { render :edit }
        format.json { render json: @product_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_stocks/1
  # DELETE /product_stocks/1.json
  def destroy
    
    @product_stock.destroy
    # if params[:paid].present?   
    #      redirect_to productreport_path(prod: params[:prod], from_date: params[:from_date], to_date: params[:to_date], paid: params[:paid]), notice: 'Product Opening Stock was successfully removed.' 
    #     else
    #      redirect_to productreport_path(prod: params[:prod], from_date: params[:from_date], to_date: params[:to_date]), notice: 'Product Opening Stock was successfully removed.' 
    # end
    respond_to do |format|
     format.html { redirect_to product_stocks_url(:for_date => @product_stock.checked_date.strftime("%m/%d/%Y")), notice: 'Product Opening stock was successfully removed.' }
     format.json { head :no_content }
    end
  end
  
  def deletestock
     @product_stock_i = ProductStock.find(params[:id])
    @product_stock_i.destroy
    if params[:paid].present?   
         redirect_to productreport_path(prod: params[:prod], from_date: params[:from_date], to_date: params[:to_date], paid: params[:paid]), notice: 'Product Opening Stock was successfully created.' 
        else
         redirect_to productreport_path(prod: params[:prod], from_date: params[:from_date], to_date: params[:to_date]), notice: 'Product Opening Stock was successfully created.' 
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_product_stock
      @product_stock = ProductStock.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_stock_params
      params.require(:product_stock).permit(:product_master_id, :product_list_id, :current_stock, :ext_prod_code, :barcode, :checked_date, :emp_code, :emp_id)
    end
end
