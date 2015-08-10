class ProductListsController < ApplicationController
   before_action { protect_controllers(8) } 
  before_action :set_product_list, only: [:show, :edit, :update, :destroy]
   before_action :dropdowns, only: [:new, :edit]

  respond_to :html

  def index
    @showall = true
    if params.has_key?(:search)
      
      @search = "Search for " +  params[:search].upcase
      @searchvalue = params[:search].upcase   
      
      # @product_masters = ProductMaster.where('productactivecodeid = 10000').where("name like ? OR extproductcode like ? or list_barcode like ?", "#{@searchvalue}%", "#{@searchvalue}%", "#{@searchvalue}%")
      # @inactive_product_masters = ProductMaster.where('productactivecodeid <> 10000').where("name like ? OR extproductcode like ? or list_barcode like ?", "#{@searchvalue}%", "#{@searchvalue}%", "#{@searchvalue}%")
      
      @product_lists = ProductList.where('active_status_id = ?',  10000).where("name like ? OR extproductcode like ? or list_barcode like ?", "#{@searchvalue}%", "#{@searchvalue}%", "#{@searchvalue}%").paginate(:page => params[:page])
      @inactive_product_lists = ProductList.where('active_status_id <> ?',  10000).where("name like ? OR extproductcode like ? or list_barcode like ?", "#{@searchvalue}%", "#{@searchvalue}%", "#{@searchvalue}%").paginate(:page => params[:page])


      @found = @product_lists.count
      
      elsif params[:showall] == 'true'
        
       @search = "All Product Sell List"
      @searchvalue = nil

      @product_lists = ProductList.where('active_status_id = ?',  10000).order('name').paginate(:page => params[:page])
      
      @inactive_product_lists = ProductList.where('active_status_id <> ?',  10000).order('name').paginate(:page => params[:page])


      else
        @search = "Product Sell List"
        @searchvalue = nil
        #product_masters = ProductMaster.where("productactivecodeid = ?", 10000).pluck("id")
        #product_variants = ProductVariant.where("activeid = ? and product_sell_type_id < ?", 10000, 10002).where(productmasterid: product_masters).pluck("id")
        @product_lists = ProductList.where('active_status_id = ?',  10000).order('updated_at DESC').paginate(:page => params[:page])
        @inactive_product_lists = ProductList.where('active_status_id <> ?',  10000).order('updated_at DESC').paginate(:page => params[:page])

        @found = nil
      
    end
  end



  def show
    respond_with(@product_list)
  end

  def new
    @product_list = ProductList.new
    respond_with(@product_list)
  end

  def edit
  end

  def create
    @product_list = ProductList.new(product_list_params)
    variant_name = ProductVariant.find(product_list_params[:product_variant_id])
    spec_name = ProductSpecList.find(product_list_params[:product_spec_list_id])
    @product_list.name = variant_name.name << " " << spec_name.name
    if  @product_list.save
      @product_list.save(:validate => false)
        flash[:success] = "Product List was created successfully." 
        respond_with(@product_list.product_variant)
      else
         flash[:error] = @product_list.errors.full_messages.join("<br/>")
        respond_with(@product_list)
    end
  end

  def update
    @product_list.update(product_list_params)
    if @product_list.errors.any?
        flash[:error] = @product_list.errors.full_messages.join("<br/>")
        respond_with(@product_list)
      else
        flash[:success] = "Product List was updated successfully." 
        respond_with(@product_list.product_variant)
    end
  end

  def destroy
    @product_list.destroy
    respond_with(@product_list.product_variant)
  end

  private

    def set_product_list
      @product_list = ProductList.find(params[:id])
    end

    def dropdowns
      @product_variants = ProductVariant.all.order("name")
      @product_specs = ProductSpecList.all.order("name")
      @product_masters = ProductMaster.all.order("name")
    end

    def product_list_params
      params.require(:product_list).permit(:name, :product_variant_id,
       :product_spec_list_id, :extproductcode, 
       :list_barcode, :active_status_id, :product_master_id)
    end
end
