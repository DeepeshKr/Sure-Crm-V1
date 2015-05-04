class ProductStockAdjustsController < ApplicationController
  before_action :set_product_stock_adjust, only: [:show, :edit, :update, :destroy]

  # GET /product_stock_adjusts
  # GET /product_stock_adjusts.json
  def index
    @product_stock_adjusts = ProductStockAdjust.all
  end

  # GET /product_stock_adjusts/1
  # GET /product_stock_adjusts/1.json
  def show
  end

  # GET /product_stock_adjusts/new
  def new
    @product_stock_adjust = ProductStockAdjust.new
  end

  # GET /product_stock_adjusts/1/edit
  def edit
  end

  # POST /product_stock_adjusts
  # POST /product_stock_adjusts.json
  def create
    @product_stock_adjust = ProductStockAdjust.new(product_stock_adjust_params)

    respond_to do |format|
      if @product_stock_adjust.save
        format.html { redirect_to @product_stock_adjust, notice: 'Product Journal was successfully created.' }
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
        format.html { redirect_to @product_stock_adjust, notice: 'Product stock adjust was successfully updated.' }
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
      format.html { redirect_to product_stock_adjusts_url, notice: 'Product Journal was successfully destroyed.' }
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
