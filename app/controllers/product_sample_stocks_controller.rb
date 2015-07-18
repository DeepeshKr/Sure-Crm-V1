class ProductSampleStocksController < ApplicationController
  before_action { protect_controllers_specific(6) } 
  before_action :set_product_sample_stock, only: [:show, :edit, :update, :destroy]

  # GET /product_sample_stocks
  # GET /product_sample_stocks.json
  def index
    @product_sample_stocks = ProductSampleStock.all
  end

  # GET /product_sample_stocks/1
  # GET /product_sample_stocks/1.json
  def show
  end

  # GET /product_sample_stocks/new
  def new
    @product_sample_stock = ProductSampleStock.new
  end

  # GET /product_sample_stocks/1/edit
  def edit
  end

  # POST /product_sample_stocks
  # POST /product_sample_stocks.json
  def create
    @product_sample_stock = ProductSampleStock.new(product_sample_stock_params)

    respond_to do |format|
      if @product_sample_stock.save
        format.html { redirect_to @product_sample_stock, notice: 'Product sample stock was successfully created.' }
        format.json { render :show, status: :created, location: @product_sample_stock }
      else
        format.html { render :new }
        format.json { render json: @product_sample_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /product_sample_stocks/1
  # PATCH/PUT /product_sample_stocks/1.json
  def update
    respond_to do |format|
      if @product_sample_stock.update(product_sample_stock_params)
        format.html { redirect_to @product_sample_stock, notice: 'Product sample stock was successfully updated.' }
        format.json { render :show, status: :ok, location: @product_sample_stock }
      else
        format.html { render :edit }
        format.json { render json: @product_sample_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_sample_stocks/1
  # DELETE /product_sample_stocks/1.json
  def destroy
    @product_sample_stock.destroy
    respond_to do |format|
      format.html { redirect_to product_sample_stocks_url, notice: 'Product sample stock was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_sample_stock
      @product_sample_stock = ProductSampleStock.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_sample_stock_params
      params.require(:product_sample_stock).permit(:product_master_id, :product_list_id, :product_name, :prod_code, :barcode, :basic_price, :shipping, :air_date, :orders, :stock, :description)
    end
end
