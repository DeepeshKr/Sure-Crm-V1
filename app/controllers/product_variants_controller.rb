class ProductVariantsController < ApplicationController
  before_action :set_product_variant, only: [:show, :edit, :update, :destroy]

  respond_to :html, :xml, :json

  def index
    @product_variants = ProductVariant.all
    respond_with(@product_variants)
  end

  def show
    @product_lists = ProductList.where(product_variant_id: @product_variant.id)
    @product_list = ProductList.new(:product_variant_id => @product_variant.id)

    @product_spec_list = ProductSpecList.all.order("id")
    respond_with(@product_variant,  @product_list, @product_lists)
  end

  def new
    # def product_list_params
    #   params.require(:product_list).permit(:name, :product_variant_id,
    # :product_spec_list_id, :extproductcode, :list_barcode, :active_status_id)
    # end
    @product_variant = ProductVariant.new()
    respond_with(@product_variant)
  end

  def edit
  end

  def details
    if params.has_key?(:variant_id)
       results = ProductVariant.where('id = ?', params[:variant_id])
       if results.exists?
         @result =  results.first.name + " - " + results.first.extproductcode 
       else
        @result = nil
       end
     
    else 
       @result = nil
    end
  end

  def combined
    if params.has_key?(:variant_id)
       results = ProductVariant.where('id = ?', params[:variant_id])
       if results.exists?
         @combined =  results.first.name + "-" + results.first.extproductcode + "-" + results.first.price.to_i.to_s + "-" + results.first.shipping.to_i.to_s 
          @pro_code = results.first.extproductcode
       else
        @combined = nil
        @pro_code = nil
       end
     
    else
       @combined = nil
       @pro_code = nil
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
       @productactivecode = ProductActiveCode.all.order("id")
     @productselltype = ProductSellType.all.order("id")
    
    end

    def product_variant_params
      params.require(:product_variant).permit(:name, :productmasterid, :variantbarcode, 
      :price, :taxes,  :shipping, :extproductcode, :description, :activeid, :product_sell_type_id)
    end
end
