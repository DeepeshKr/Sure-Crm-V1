class ProductSellTypesController < ApplicationController
   before_action { protect_controllers(8) } 
  before_action :set_product_sell_type, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @product_sell_types = ProductSellType.all
    respond_with(@product_sell_types)
  end

  def show
    @product_variants = ProductVariant.where("product_sell_type_id = ?", @product_sell_type.id )
    respond_with(@product_sell_type, @product_variants)
  end

  def new
    @product_sell_type = ProductSellType.new
    respond_with(@product_sell_type)
  end

  def edit
  end

  def create
    @product_sell_type = ProductSellType.new(product_sell_type_params)
    @product_sell_type.save
    respond_with(@product_sell_type)
  end

  def update
    @product_sell_type.update(product_sell_type_params)
    respond_with(@product_sell_type)
  end

  def destroy
    @product_sell_type.destroy
    respond_with(@product_sell_type)
  end

  private
    def set_product_sell_type
      @product_sell_type = ProductSellType.find(params[:id])
    end

    def product_sell_type_params
      params.require(:product_sell_type).permit(:name, :description)
    end
end
