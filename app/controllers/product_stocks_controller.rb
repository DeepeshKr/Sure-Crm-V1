class ProductStocksController < ApplicationController
  before_action :set_product_stock, only: [:show, :edit, :update, :destroy]

  # GET /product_stocks
  # GET /product_stocks.json
  def index
    @product_stocks = ProductStock.all
  end

  # GET /product_stocks/1
  # GET /product_stocks/1.json
  def show
  end

  # GET /product_stocks/new
  def new
    @product_stock = ProductStock.new
  end

  # GET /product_stocks/1/edit
  def edit
  end

  # POST /product_stocks
  # POST /product_stocks.json
  def create
    @product_stock = ProductStock.new(product_stock_params)

    respond_to do |format|
      if @product_stock.save
        if params[:paid].present?   
          format.html { redirect_to productreport_path(prod: params[:prod], from_date: params[:from_date], to_date: params[:to_date], paid: params[:paid]), notice: 'Product Opening Stock was successfully created.' }
        else
          format.html { redirect_to productreport_path(prod: params[:prod], from_date: params[:from_date], to_date: params[:to_date]), notice: 'Product Opening Stock was successfully created.' }
        end
		  
      
        #redirect_to payment_path(:order_id => @order_master.id)
        #format.html { redirect_to @product_stock, notice: 'Product Opening Stock was successfully created.' }
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
        format.html { redirect_to @product_stock, notice: 'Product Opening stock was successfully updated.' }
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
    if params[:paid].present?   
         redirect_to productreport_path(prod: params[:prod], from_date: params[:from_date], to_date: params[:to_date], paid: params[:paid]), notice: 'Product Opening Stock was successfully removed.' 
        else
         redirect_to productreport_path(prod: params[:prod], from_date: params[:from_date], to_date: params[:to_date]), notice: 'Product Opening Stock was successfully removed.' 
    end
    #respond_to do |format|
    #  
    #  format.html { redirect_to product_stocks_url, notice: 'Product Opening stock was successfully destroyed.' }
    #  format.json { head :no_content }
    #end
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
