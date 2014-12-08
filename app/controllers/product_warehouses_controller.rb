class ProductWarehousesController < ApplicationController
  before_action :set_product_warehouse, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @product_warehouses = ProductWarehouse.all
    respond_with(@product_warehouses)
  end

  def show
    respond_with(@product_warehouse)
  end

  def new
    @product_warehouse = ProductWarehouse.new
    respond_with(@product_warehouse)
  end

  def edit
  end

  def create
    @product_warehouse = ProductWarehouse.new(product_warehouse_params)
    @product_warehouse.save
    respond_with(@product_warehouse)
  end

  def update
    @product_warehouse.update(product_warehouse_params)
    respond_with(@product_warehouse)
  end

  def destroy
    @product_warehouse.destroy
    respond_with(@product_warehouse)
  end

  private
    def set_product_warehouse
      @product_warehouse = ProductWarehouse.find(params[:id])
    end

    def product_warehouse_params
      params.require(:product_warehouse).permit(:location_name, :address1, :address2, :address3, :landmark, :city, :pincode, :state, :country, :telephone1, :telephone2, :fax, :emailid, :description)
    end
end
