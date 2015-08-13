class ProductMastersController < ApplicationController
   before_action { protect_controllers(8) } 
  before_action :set_product_master, only: [:show, :edit, :update, :destroy]
before_action :dropdownlist
  #respond_to :html
respond_to :html, :xml, :json

  def index
     @showall = true
    if params.has_key?(:search) 
      
      @search = "Search for " +  params[:search].upcase
      @searchvalue = params[:search].upcase   
      @product_masters = ProductMaster.where('productactivecodeid = 10000')
      .where("name like ? OR extproductcode like ? or description like ?", "#{@searchvalue}%",
       "#{@searchvalue}%", "#{@searchvalue}%")
      .paginate(:page => params[:page], :per_page => 5)
      @inactive_product_masters = ProductMaster.where('productactivecodeid <> 10000').where("name like ? OR extproductcode like ? or description like ?", "#{@searchvalue}%", "#{@searchvalue}%", "#{@searchvalue}%").paginate(:page => params[:page], :per_page => 5)
      @found = @product_masters.count
     
     elsif params[:showall] == 'true'
        
       @search = "All Product Masters"
      @searchvalue = nil
     @product_masters = ProductMaster.all.where('productactivecodeid = 10000').paginate(:page => params[:page], :per_page => 5)
      @inactive_product_masters = ProductMaster.where('productactivecodeid <> 10000')
    else
      @search = "Product Master"
      @searchvalue = nil
      @product_masters = ProductMaster.all.where('productactivecodeid = 10000').order('updated_at DESC').limit(10).paginate(:page => params[:page], :per_page => 5)
      @inactive_product_masters = ProductMaster.where('productactivecodeid <> 10000').order('updated_at DESC').limit(10).paginate(:page => params[:page], :per_page => 5)
      
      @found = nil
    
    end

    
  end

   def listofproducts
    
      @product_masters = ProductMaster.all.where('productactivecodeid = 10000')
      @inactive_product_masters = ProductMaster.where('productactivecodeid <> 10000').limit(10)
      
     
   end

  def show
  #  respond_with(@product_master)
     @product_variants = ProductVariant.where("productmasterid = ?" ,  @product_master.id)
     @product_variant = ProductVariant.new(productmasterid:  @product_master.id,
      name: @product_master.name, 
      price: @product_master.price, 
      activeid: true,
      taxes: @product_master.taxes || 0, shipping: @product_master.shipping,
     total: @product_master.total, variantbarcode: 
     @product_master.barcode, description: @product_master.description,
     extproductcode: @product_master.extproductcode)

     
        @product_training_manuals = ProductTrainingManual.where("productid = ?",  @product_master.id)
      @product_training_manual = ProductTrainingManual.new
      @product_training_manual.productid =  @product_master.id
       @product_training_headings = ProductTrainingHeading.all
      #productmasters = ProductMaster.where('product_sell_type_id = 1').pluck(:id)
     # product_add_on_l = ProductVariantAddOn.where(productid: productmasters).pluck(:productvariantid)
      
      @product_add_on_lists  = ProductVariant.joins(:product_master)
      .where(product_masters: { product_sell_type_id: 10001 })
      .where(product_masters: { product_sell_type_id: 10040 })
       .where(product_sell_type_id: 10001)
       .where(product_sell_type_id: 10040)

      #Author.joins(:articles).where(articles: { author: author })
      
      if @product_master.product_sell_type.present?
        if @product_master.product_sell_type_id = 10000
          #show all add on to be added into this product
        #  if @product_master.product_variant_add_on.present?
          @product_master_add_ons = ProductMasterAddOn.where("product_master_id = ?" ,  @product_master.id)
        #  end  
          @product_master_add_on = ProductMasterAddOn.new(product_master_id: @product_master.id, change_price: 0)
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
     #@product_master.taxes =  0
     @productactivecode = ProductActiveCode.all.order("id")
     @productselltype = ProductSellType.where("id = ?", 10000)
    product_sell_type
    @product_master = ProductMaster.new(taxes: 0)
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
    def dropdownlist
      @productactivecode = ProductActiveCode.all.order("id")
      @productselltype = ProductSellType.all.order("id")
      @productspecificaddonlist = ProductList.joins(:product_variant).where("product_variants.product_sell_type_id = ? ", 10040)
      @productreplaceaddonlist = ProductList.joins(:product_variant)
      .where("product_variants.product_sell_type_id = ? ", 10000)
      .order("product_variants.name")
    end 

    def product_sell_type
      @product_sell_types = ProductSellType.all.order("id")
    end
    def set_product_master
      @product_master = ProductMaster.find(params[:id])
    end

    def product_master_params
      params.require(:product_master).permit(:name, :productcategoryid, 
        :productinventorycodeid, 
      :barcode, :price, :taxes,  :shipping, :extproductcode, :description, 
      :productactivecodeid, 
      :product_sell_type_id)
    end
end
