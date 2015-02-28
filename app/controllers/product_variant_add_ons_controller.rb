class ProductVariantAddOnsController < ApplicationController
  before_action :set_product_variant_add_on, only: [:show, :edit, :update, :destroy]
  before_action :dropdowns, only: [:new, :edit]
  respond_to :html

  def index
    @product_variant_add_ons = ProductVariantAddOn.all
    respond_with(@product_variant_add_ons)
  end

  def show
    respond_with(@product_variant_add_on)
  end

  def new
   
    @product_variant_add_on = ProductVariantAddOn.new
    respond_with(@product_variant_add_on)
  end

  def edit
    
  end

  def create
    @product_variant_add_on = ProductVariantAddOn.new(product_variant_add_on_params)
    @product_variant_add_on.save
    if @product_variant_add_on.save
      respond_with(@product_variant_add_on.product_master)
    else
       
      respond_with(@product_variant_add_on)
    end
 
  end

  def update
    @product_variant_add_on.update(product_variant_add_on_params)
    respond_with(@product_variant_add_on.product_master)
  end

  def destroy
    @product_variant_add_on.destroy
    respond_with(@product_variant_add_on.product_master)
  end

  private
  def dropdowns
     @product_add_on_lists  = ProductVariant.joins(:product_master)
      .where(product_masters: { product_sell_type_id: 2 })

      @product_master_lists  = ProductMaster.where(product_sell_type_id: 1)
  end
    def set_product_variant_add_on
      @product_variant_add_on = ProductVariantAddOn.find(params[:id])
    end

    def product_variant_add_on_params
      params.require(:product_variant_add_on).permit(:product_master_id, :product_variant_id)
    end
end
