class ProductMasterAddOnsController < ApplicationController
   before_action { protect_controllers(8) } 
  before_action :set_product_master_add_on, only: [:show, :edit, :update, :destroy]

  respond_to :html, :xml, :json

  def index
    @product_master_add_ons = ProductMasterAddOn.all.order("product_master_id")
    #@product_master_add_ons = ProductMasterAddOn.where(product_master_id: product_master_id)
    respond_with(@product_master_add_ons)
  end

  def list
    
    @product_master_add_ons = ProductMasterAddOn.where(product_master_id: product_master_id)
    respond_with(@product_master_add_ons)
  end

  def show
    respond_with(@product_master_add_on)
  end

  def new
    @product_master_add_on = ProductMasterAddOn.new
    respond_with(@product_master_add_on)
  end

  def edit
  end

  def create
    @product_master_add_on = ProductMasterAddOn.new(product_master_add_on_params)
    @product_master_add_on.save
    respond_with(@product_master_add_on.product_master)
  end

  def update
    @product_master_add_on.update(product_master_add_on_params)
    respond_with(@product_master_add_on.product_master)
  end

  def destroy
    @product_master_add_on.destroy
    respond_with(@product_master_add_on.product_master)
  end

  def product_lists
   # @product_master_add_ons = ProductList.all
   @product_master_add_ons = nil
    if ProductList.find(params[:product_list_id]).present?
    productvariantid = ProductList.find(params[:product_list_id]).product_variant_id
      id = params[:product_list_id]
      if ProductVariant.find(productvariantid).present?
          productid = ProductVariant.find(productvariantid).productmasterid
          if ProductMasterAddOn.where(product_master_id: productid).present? 
          @product_master_add_ons = ProductMasterAddOn.where(product_master_id: productid)
          else
          @product_master_add_ons = nil
          end
        else
           @product_master_add_ons = nil
      end
    else
       @product_master_add_ons = nil
    end  
  
    #render json: @product_master_add_on
  end

  private
    def set_product_master_add_on
      @product_master_add_on = ProductMasterAddOn.find(params[:id])
    end

    def product_master_add_on_params
      params.require(:product_master_add_on).permit(:product_master_id, :product_list_id, :activeid, :change_price)
    end
end
