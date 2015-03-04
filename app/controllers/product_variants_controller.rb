class ProductVariantsController < ApplicationController
  before_action :set_product_variant, only: [:show, :edit, :update, :destroy]

  respond_to :html, :xml, :json

  def index
    @product_variants = ProductVariant.all
    respond_with(@product_variants)
  end

  def show
    respond_with(@product_variant)
  end

  def new
    @product_variant = ProductVariant.new
    respond_with(@product_variant.product_master)
  end

  def edit
  end

  def details
    if(params.has_key?(:id) 
       product = ProductVariant.find('id = ?', params[:id])   
      @details =  product.name << "(" << product.extproductcode << ")"
    end
  end

  def create
    @product_variant = ProductVariant.new(product_variant_params)
    @product_variant.total = @product_variant.price + @product_variant.taxes + @product_variant.shipping
    @product_variant.save
    if @product_variant.save
      respond_with(@product_variant.product_master)
    else
       
      respond_with(@product_variant)
    end
    
  end
   
  def update 
       @product_variant.update(product_variant_params)   
     
     if @product_variant.update(product_variant_params)
       total = @product_variant.price + @product_variant.taxes + @product_variant.shipping
        @product_variant.update!(total: total)
      #respond_with(@product_variant)
      respond_with(@product_variant.product_master)
    else
      respond_with(@product_variant)
    end
   # respond_with(@product_variant.product_master)
  end

  def destroy
    @product_variant.destroy
    respond_with(@product_variant)
  end

  private
    def set_product_variant
      @product_variant = ProductVariant.find(params[:id])
    end

    def product_variant_params
      params.require(:product_variant).permit(:name, :productmasterid, :variantbarcode, 
      :price, :taxes,  :shipping, :extproductcode, :description, :activeid, :product_sell_type_id)
    end
end
