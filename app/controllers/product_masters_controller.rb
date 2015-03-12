class ProductMastersController < ApplicationController
  before_action :set_product_master, only: [:show, :edit, :update, :destroy]

  #respond_to :html
respond_to :html, :xml, :json

  def index
    @product_masters = ProductMaster.all
    respond_with(@product_masters)
  end

  def show
  #  respond_with(@product_master)
     @product_variants = ProductVariant.where("productmasterid = ?" ,  @product_master.id)
     @product_variant = ProductVariant.new
     @product_variant.productmasterid =  @product_master.id
     @product_variant.name = @product_master.name
     @product_variant.price = @product_master.price
     
     @product_variant.taxes = @product_master.taxes || 0

     @product_variant.shipping = @product_master.shipping
     @product_variant.total = @product_master.total
     @product_variant.variantbarcode = @product_master.barcode
      @product_variant.description = @product_master.description
      @product_training_manuals = ProductTrainingManual.where("productid = ?",  @product_master.id)
      @product_training_manual = ProductTrainingManual.new
      @product_training_manual.productid =  @product_master.id
      #productmasters = ProductMaster.where('product_sell_type_id = 1').pluck(:id)
     # product_add_on_l = ProductVariantAddOn.where(productid: productmasters).pluck(:productvariantid)
      
      @product_add_on_lists  = ProductVariant.joins(:product_master)
      .where(product_masters: { product_sell_type_id: 2 })

      #Author.joins(:articles).where(articles: { author: author })
      
      if @product_master.product_sell_type.present?
        if @product_master.product_sell_type_id = 1
          #show all add on to be added into this product
        #  if @product_master.product_variant_add_on.present?
          @product_add_ons = ProductVariantAddOn.where("product_master_id = ?" ,  @product_master.id)
        #  end 
          @product_variant_add_on = ProductVariantAddOn.new
          @product_variant_add_on.product_master_id = @product_master.id
          @productaddonhead = "No Add on found"
        else
            @productaddonhead = "You cannot add-on to a Add On"
        end
      else
        @productaddonhead = "No Add on found"
      end
    respond_with(@product_master, @product_variants,  @product_variant,
     @product_training_manuals, @product_training_manual, @product_add_ons, @product_variant_add_on)
  end

  def new
     @product_master.taxes = @product_master.taxes || 0
    product_sell_type
    @product_master = ProductMaster.new
    respond_with(@product_master)
  end

  def edit
     @product_master.taxes = @product_master.taxes || 0
    product_sell_type
  end

  def create
    @product_master = ProductMaster.new(product_master_params)
    @product_master.total = @product_master.price + @product_master.taxes + @product_master.shipping
    @product_master.save
    respond_with(@product_master)
  end

  
  def update
      
     
     @product_master.update(product_master_params)
     total = @product_master.taxes + @product_master.shipping + @product_master.price
      
      unless @product_master.taxes? || @product_master.taxes == 0
          total += @product_master.taxes
      end
      unless @product_master.shipping? || @product_master.shipping == 0
          total += @product_master.shipping
      end
      unless @product_master.price? || @product_master.price == 0
          total += @product_master.price
      end
     
     @product_master.update!(total: total)
    
     
    respond_with(@product_master)
  end

  def destroy
    @product_master.destroy
    respond_with(@product_master)
  end

  def details() 
    if !params.blank?
           @productname = @product_master.name
           @producttaxes = @product_master.taxes
           @productshipping = @product_master.shipping
           @productprice = @product_master.price
           @producttotal = @product_master.total
           @productdescription = @product_master.description
           @productbarcode = @product_master.barcode
           @extproductcode = @product_master.extproductcode
      end 
    
  end
  
  private
    def product_sell_type
      @product_sell_types = ProductSellType.all
    end
    def set_product_master
      @product_master = ProductMaster.find(params[:id])
    end

    def product_master_params
      params.require(:product_master).permit(:name, :productcategoryid, :productinventorycodeid, 
      :barcode, :price, :taxes,  :shipping, :extproductcode, :description, :productactivecodeid, 
      :product_sell_type_id)
    end
end