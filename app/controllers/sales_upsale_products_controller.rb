class SalesUpsaleProductsController < ApplicationController
  before_action :set_sales_upsale_product, only: [:show, :edit, :update, :destroy]
  before_action :set_product_list
  # GET /sales_upsale_products
  # GET /sales_upsale_products.json
  def index
    @sales_upsale_products = SalesUpsaleProduct.all
  end

  # GET /sales_upsale_products/1
  # GET /sales_upsale_products/1.json
  def show
  end

  # GET /sales_upsale_products/new
  def new
   
    @sales_upsale_product = SalesUpsaleProduct.new
  end

  # GET /sales_upsale_products/1/edit
  def edit
    @product_list = ProductList.order('extproductcode')
  end

  # POST /sales_upsale_products
  # POST /sales_upsale_products.json
  def create
    @sales_upsale_product = SalesUpsaleProduct.new(sales_upsale_product_params)

    respond_to do |format|
      if @sales_upsale_product.save
        format.html { redirect_to sales_upsale_products_url, notice: 'Sales upsale product was successfully created.' }
        format.json { render :show, status: :created, location: @sales_upsale_product }
      else
        format.html { render :new }
        format.json { render json: @sales_upsale_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sales_upsale_products/1
  # PATCH/PUT /sales_upsale_products/1.json
  def update
    respond_to do |format|
      if @sales_upsale_product.update(sales_upsale_product_params)
        format.html { redirect_to @sales_upsale_product, notice: 'Sales upsale product was successfully updated.' }
        
        format.json { render :show, status: :ok, location: @sales_upsale_product }
      else
        format.html { render :edit }
        format.json { render json: @sales_upsale_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales_upsale_products/1
  # DELETE /sales_upsale_products/1.json
  def destroy
    @sales_upsale_product.destroy
    respond_to do |format|
      format.html { redirect_to sales_upsale_products_url, notice: 'Sales upsale product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sales_upsale_product
      @sales_upsale_product = SalesUpsaleProduct.find(params[:id])
    end
    def set_product_list
      @product_list = ProductList.joins(:product_variant)
      .where("product_variants.product_sell_type_id in (?)", [10040, 10001])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def sales_upsale_product_params
      params.require(:sales_upsale_product).permit(:product_list_id)
    end
end
