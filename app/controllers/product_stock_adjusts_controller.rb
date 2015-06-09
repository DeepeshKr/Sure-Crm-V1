class ProductStockAdjustsController < ApplicationController
  before_action :set_product_stock_adjust, only: [:show, :edit, :update, :destroy]

  # GET /product_stock_adjusts
  # GET /product_stock_adjusts.json
  def index
    if params[:for_date].present?
      for_date =  Date.strptime(params[:for_date], "%m/%d/%Y")
      @product_stock_adjusts = ProductStockAdjust.where('TRUNC(created_date) = ?',for_date)

        @product_stock_adjust = ProductStockAdjust.new(created_date: for_date)
        @for_date_display = for_date.strftime("%d-%b-%Y")

    else
       @product_stock_adjust = ProductStockAdjust.new
      @for_date_display = "No Date selected showing 100 Recently changed"
      @product_stock_adjusts = ProductStockAdjust.all.limit(100).order("updated_at DESC")
    end

  @productmasterlist = ProductMaster.all.order("name, extproductcode")
      
    #@product_stock_adjusts = ProductStockAdjust.all
  end

  # GET /product_stock_adjusts/1
  # GET /product_stock_adjusts/1.json
  def show
  end

  # GET /product_stock_adjusts/new
  def new
    @productmasterlist = ProductMaster.all.order("name, extproductcode")
    @product_stock_adjust = ProductStockAdjust.new
  end

  # GET /product_stock_adjusts/1/edit
  def edit
    @productmasterlist = ProductMaster.all.order("name, extproductcode")
  end

  # POST /product_stock_adjusts
  # POST /product_stock_adjusts.json
  def create
    @product_stock_adjust = ProductStockAdjust.new(product_stock_adjust_params)

    respond_to do |format|
      if @product_stock_adjust.save
          product_master = ProductMaster.find(@product_stock_adjust.product_master_id)
        @product_stock_adjust.update(ext_prod_code: product_master.extproductcode)
       
        format.html { redirect_to product_stock_adjusts_url, notice: 'Product Journal was successfully created.' }
        format.json { render :show, status: :created, location: @product_stock_adjust }
      else
        format.html { render :new }
        format.json { render json: @product_stock_adjust.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /product_stock_adjusts/1
  # PATCH/PUT /product_stock_adjusts/1.json
  def update
    respond_to do |format|
      if @product_stock_adjust.update(product_stock_adjust_params)
         product_master = ProductMaster.find(@product_stock_adjust.product_master_id)
        @product_stock_adjust.update(ext_prod_code: product_master.extproductcode)
       
        format.html { redirect_to product_stock_adjusts_url, notice: 'Product stock adjust was successfully updated.' }
        format.json { render :show, status: :ok, location: @product_stock_adjust }
      else
        format.html { render :edit }
        format.json { render json: @product_stock_adjust.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_stock_adjusts/1
  # DELETE /product_stock_adjusts/1.json
  def destroy
    @product_stock_adjust.destroy
    respond_to do |format|
      format.html {redirect_to product_stock_adjusts_url, notice: 'Product Journal was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_stock_adjust
      @product_stock_adjust = ProductStockAdjust.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_stock_adjust_params
      params.require(:product_stock_adjust).permit(:product_master_id, :product_list_id, :change_stock, :ext_prod_code, :barcode, :created_date, :emp_code, :emp_id, :name, :description, :total, :rate)
    end
end
