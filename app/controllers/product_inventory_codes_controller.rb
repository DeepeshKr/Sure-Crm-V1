class ProductInventoryCodesController < ApplicationController
  before_action :set_product_inventory_code, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @product_inventory_codes = ProductInventoryCode.all
    respond_with(@product_inventory_codes)
  end

  def show
    respond_with(@product_inventory_code)
  end

  def new
    @product_inventory_code = ProductInventoryCode.new
    respond_with(@product_inventory_code)
  end

  def edit
  end

  def create
    @product_inventory_code = ProductInventoryCode.new(product_inventory_code_params)
    @product_inventory_code.save
    respond_with(@product_inventory_code)
  end

  def update
    @product_inventory_code.update(product_inventory_code_params)
    respond_with(@product_inventory_code)
  end

  def destroy
    @product_inventory_code.destroy
    respond_with(@product_inventory_code)
  end

  private
    def set_product_inventory_code
      @product_inventory_code = ProductInventoryCode.find(params[:id])
    end

    def product_inventory_code_params
      params.require(:product_inventory_code).permit(:name, :sortorder)
    end
end
