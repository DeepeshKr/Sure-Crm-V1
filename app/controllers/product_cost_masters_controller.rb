class ProductCostMastersController < ApplicationController

  before_action :set_product_cost_master, only: [:show, :edit, :update, :destroy]
  before_action { protect_controllers(5) }
  before_action :set_default_values
  # GET /product_cost_masters
  # GET /product_cost_masters.json
  def index
    
    @product_cost_masters = ProductCostMaster.all.order(created_at: :DESC).paginate(:page => params[:page])
    #update_all
    #reset_prices

    respond_to do |format|
      format.html
      format.csv do
        @product_cost_masters = ProductCostMaster.all
              headers['Content-Disposition'] = "attachment; filename=\"product-costs\""
              headers['Content-Type'] ||= 'text/csv'
      end
    end
  end

  def product_costs
    @page_heading = "Product cost search"
    @showall = true
    #reset_prices
    # @all_product_cost_masters = ProductCostMaster.where("product_list_id IS NOT NULL").pluck(:product_list_id)
  #   @all_product_cost_masters_prod = ProductCostMaster.where("prod IS NOT NULL").pluck(:prod)
  #   @all_product_variant_prod = ProductVariant.where("extproductcode IS NOT NULL").pluck(:extproductcode)
  #   @all_product_master_prod = ProductMaster.where("extproductcode IS NOT NULL").pluck(:extproductcode)

    # @product_cost_masters = ProductCostMaster.where("product_list_id IS NOT NULL").pluck(:product_list_id)
    if params.has_key?(:search)
        @search = "Search for " +  params[:search].upcase
        @searchvalue = params[:search].upcase

        @product_cost_masters = ProductCostMaster.joins(:product_variant).where("UPPER(product_cost_masters.prod) like ? OR UPPER(product_cost_masters.barcode) like ? OR UPPER(product_variants.name) like ? ",
          "#{@searchvalue}%", "#{@searchvalue}%", "#{@searchvalue}%").paginate(:page => params[:page])

        # @inactive_product_lists = ProductList.where('id NOT IN (?)', @all_product_cost_masters)
 #          .where("UPPER(name) like ? OR UPPER(extproductcode) like ? or UPPER(list_barcode) like ?",
 #          "#{@searchvalue}%", "#{@searchvalue}%", "#{@searchvalue}%")
 #          .paginate(:page => params[:page])
 #
 #        @inactive_product_variants = ProductVariant.where('extproductcode NOT IN (?)',
 #          @all_product_cost_masters_prod).where("UPPER(name) like ? OR UPPER(extproductcode) like ?",
 #          "#{@searchvalue}%", "#{@searchvalue}%")

        @found = @product_cost_masters.count
        @page_heading = "Product cost search #{@searchvalue}"
      else
        @search = "Product Sell List"
        @searchvalue = nil

        @product_cost_masters = ProductCostMaster.all.paginate(:page => params[:page])
        #.limit(10)
        @nos_with_price = @product_cost_masters.count()

        # @inactive_product_lists = ProductList.where('id NOT IN (?)',   @all_product_cost_masters)
#         .order('updated_at DESC').paginate(:page => params[:page])
#         #.where('active_status_id = ?',  10000) .limit(10)
#         @nos_with_out_price = @inactive_product_lists.count()
#         @found = nil
#
#         @inactive_product_variants = ProductVariant.where('extproductcode NOT IN (?)',
#         @all_product_cost_masters_prod) #.limit(10)
        
        @page_heading = "Product cost search => showing all"
        
    end
        # format.csv do
        #     headers['Content-Disposition'] = "attachment; filename=\"product-costs\""
        #     headers['Content-Type'] ||= 'text/csv'
        # end

  end
  
  def update_all_product_costs
    @return_url = product_cost_masters_url
     
    # ProductCostMaster.create_product_cost_master 15385
    product_variants = ProductVariant.all
    product_variants.each do |pv|
      ProductCostMaster.create_product_cost_master pv.id
    end

    ProductCostMaster.update_product_cost_master

    product_cost_masters = ProductCostMaster.all
    product_cost_masters.each do |pc|
      ppu = ProductCostMaster.find(pc.id)
      ppu.update_price
    end
    
    
    if params.has_key?(:return_url)
      @return_url = params[:return_url]
    end
    redirect_to product_cost_masters_path, notice: "All products costs have been updated with tax rates"
  end
  
  def update_product_cost
    
    @return_url = product_cost_masters_url
    search = nil
    if params.has_key?(:product_variant_id)
      @product_variant_id = params[:product_variant_id]
      ProductCostMaster.create_product_cost_master @product_variant_id
      search = ProductVariant.find(@product_variant_id).extproductcode
    end
    
    if params.has_key?(:product_cost_master_id)
      @product_cost_master_id = params[:product_cost_master_id]
      ppu = ProductCostMaster.find(@product_cost_master_id)
      ppu.update_price
      search = ppu.prod
    end
    
    if params.has_key?(:return_url)
      @return_url = params[:return_url]
    end
    redirect_to product_cost_masters_path(search: search), notice: "All products costs have been updated with tax rates"
  end
  
  def product_costs_not_found
    @product_cost_masters = ProductCostMaster.where("product_list_id IS NOT NULL").pluck(:product_list_id)

    @inactive_product_lists = ProductList.where('id NOT IN (?)',   @product_cost_masters).where('active_status_id = ?',  10000).order('updated_at DESC')

    respond_to do |format|
      format.csv do
              headers['Content-Disposition'] = "attachment; filename=\"product_costs_not_found.csv\""
              headers['Content-Type'] ||= 'text/csv'
      end
    end
  end
  
  def product_cost_call_centre_commission
    
  end
  # GET /product_cost_masters/1
  # GET /product_cost_masters/1.json
  def show
    @reverse_vat_rate = TaxRate.find(10001)
    @reverse_ship_rate = TaxRate.find(10020)
    @reverse_transfer_rate = TaxRate.find(10040)
    @reverse_dealer_rate = TaxRate.find(10041)
    @product_variant = ProductVariant.find_by_extproductcode(@product_cost_master.prod)
    
  end

  # GET /product_cost_masters/new
  def new
     prod = nil
     product_list_id = nil
    if params.has_key?(:prod)
      prod = params[:prod]
    end
    if params.has_key?(:product_list_id)
      product_list_id = params[:product_list_id]
      product_list = ProductList.find(product_list_id)
      product_id = product_list.product_master_id
    end
    @product_cost_master = ProductCostMaster.new(prod: prod,
      product_list_id: product_list_id, product_id: product_id, :product_cost => 0,
      :basic_cost => 0, :shipping_handling => 0, :postage => 0,
      :tel_cost => 0, :transf_order_basic => 0, :dealer_network_basic => 0,
       :wholesale_variable_cost => 0, :royalty => 0, :cost_of_return => 0,
        :call_centre_commission => 0, packaging_cost: 0)
  end

  # GET /product_cost_masters/1/edit
  def edit
  end

  # POST /product_cost_masters
  # POST /product_cost_masters.json
  def create

    @product_cost_master = ProductCostMaster.new(product_cost_master_params)
    if  @product_cost_master.save
    flash[:success] = 'You have added prices successfully!'
    redirect_to productwithcosts_path
   else
     flash[:error] = @product_cost_master.errors.full_messages.to_sentence
     flash[:notice] = @product_cost_master.errors.full_messages.to_sentence
     respond_to do |format|
       format.html { render :new }
       format.json { render json: @product_cost_master.errors, status: :unprocessable_entity }
     end

   end

    # respond_to do |format|
    #   if @product_cost_master.save
    #     redirect_to productwithcosts_path
    #     #format.html { redirect_to @product_cost_master, notice: 'Product cost master was successfully created.' }
    #     #format.json { render :show, status: :created, location: @product_cost_master }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @product_cost_master.errors, status: :unprocessable_entity }
    #   end
    # end

  end

  # PATCH/PUT /product_cost_masters/1
  # PATCH/PUT /product_cost_masters/1.json
  def update

       @product_cost_master.update(product_cost_master_params)
        flash[:success] = 'You have updated prices successfully!'
        redirect_to productwithcosts_path
    # respond_to do |format|
    #   if @product_cost_master.update(product_cost_master_params)
    #     redirect_to productwithcosts_path
    #    # format.html { redirect_to @product_cost_master, notice: 'Product cost master was successfully updated.' }
    #     #format.json { render :show, status: :ok, location: @product_cost_master }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @product_cost_master.errors, status: :unprocessable_entity }
    #   end
    # end

  end

  # DELETE /product_cost_masters/1
  # DELETE /product_cost_masters/1.json
  def destroy
    @product_cost_master.destroy
    # respond_to do |format|
    #   format.html { redirect_to product_cost_masters_url, notice: 'Product cost master was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
     flash[:success] = 'You have removed prices successfully!'
    redirect_to productwithcosts_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_cost_master
      @product_cost_master = ProductCostMaster.find(params[:id])
     
    end
    def set_default_values
      @reverse_vat_rate = TaxRate.find(10001)
      @reverse_ship_rate = TaxRate.find(10020)
      @reverse_transfer_rate = TaxRate.find(10040)
      @reverse_dealer_rate = TaxRate.find(10041)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_cost_master_params
      params.require(:product_cost_master).permit(:product_id, :product_list_id,
        :prod, :barcode, :product_cost, :basic_cost,
        :shipping_handling, :postage,
        :tel_cost, :transf_order_basic,
        :dealer_network_basic,
        :wholesale_variable_cost,
        :royalty, :cost_of_return, :call_centre_commission,
        :packaging_cost)
    end
    
    def reset_prices
      product_cost_masters = ProductCostMaster.all

      product_cost_masters.each do |pc|
        revenue = (pc.basic_cost || 0) + (pc.shipping_handling || 0)

        cost = (pc.product_cost || 0) + (pc.tel_cost || 0) + (pc.postage || 0) + (pc.royalty || 0) + (pc.cost_of_return || 0) + (pc.call_centre_commission || 0)

        pc.update(cost:cost, revenue:revenue)
      end
    end
    
    def update_all
      #update the entire list
    @ropmasters = ROPMASTER_NEW.all
    @ropmasters.each do |rop|

        #check if found earlier else add
      product_cost_master = ProductCostMaster.where(prod: rop.prod)
      if product_cost_master.blank?
        product_id = nil
        product_list_id = nil
        prod = ProductList.where(extproductcode: rop.prod)#.pluck(:product_master_id)
        if prod.present?
          if prod.first.product_master_id.present?
            product_id = prod.first.product_master_id
          end
          product_list_id = prod.first.id
        end
        ProductCostMaster.create(product_id: product_id,
          product_list_id: product_list_id,
        prod: rop.prod,
        product_cost: rop.pc1,
        basic_cost: rop.bp1,
        postage: rop.pcb1,
        tel_cost: rop.tc1,
        transf_order_basic: rop.tcb1,
        dealer_network_basic: rop.wbp,
        wholesale_variable_cost: rop.vc1,
        royalty: rop.royalty,
        cost_of_return: rop.pack1,
        call_centre_commission: 0,
        shipping_handling: rop.sh1  )
      else
        product_cost_master = product_cost_master.first
        product_cost_master.update(product_cost: rop.pc1,
        basic_cost: rop.bp1,
        postage: rop.pcb1,
        tel_cost: rop.tc1,
        transf_order_basic: rop.tcb1,
        dealer_network_basic: rop.wbp,
        wholesale_variable_cost: rop.vc1,
        royalty: rop.royalty,
        cost_of_return: rop.pack1,
        call_centre_commission: 0,
        shipping_handling: rop.sh1  )
      end
    end

     @ropmasterhbn = ROPMASTER_HBN.where("prod = ?", @prod)
     @ropmasterhbn.each do |rop|
         #check if found earlier else add
        product_cost_master = ProductCostMaster.where(prod: rop.prod)
        if product_cost_master.blank?
        product_id = nil
        product_list_id = nil
        prod = ProductList.where(extproductcode: rop.prod)#.pluck(:product_master_id)
        if prod.present?
          if prod.first.product_master_id.present?
            product_id = prod.first.product_master_id
          end
          product_list_id = prod.first.id
        end
        ProductCostMaster.create(product_id: product_id,
        product_list_id: product_list_id,
        prod: rop.prod,
        product_cost: rop.pc1,
        basic_cost: rop.bp1,
        postage: rop.pcb1,
        tel_cost: rop.tc1,
        transf_order_basic: rop.tcb1,
        dealer_network_basic: rop.wbp,
        wholesale_variable_cost: rop.vc1,
        royalty: rop.royalty,
        cost_of_return: rop.pack1,
        call_centre_commission: 0,
        shipping_handling: rop.sh1)
        else
        product_cost_master = product_cost_master.first
        product_cost_master.update(product_cost: rop.pc1,
        basic_cost: rop.bp1,
        postage: rop.pcb1,
        tel_cost: rop.tc1,
        transf_order_basic: rop.tcb1,
        dealer_network_basic: rop.wbp,
        wholesale_variable_cost: rop.vc1,
        royalty: rop.royalty,
        cost_of_return: rop.pack1,
        call_centre_commission: 0,
        shipping_handling: rop.sh1)
         end
      end

    @ropupsprod = ROPUPSPROD.where("prod = ?", @prod)

      @ropupsprod.each do |rop|
         #check if found earlier else add
        product_cost_master = ProductCostMaster.where(prod: rop.prod)
        if product_cost_master.present?

          product_id = nil
          prod = ProductList.where(extproductcode: rop.prod).pluck(:product_master_id)
          if prod.present?
            product_id = prod.first
          end
          product_cost_master = product_cost_master.first
          product_cost_master.update(call_centre_commission: rop.comm )
         end
      end
    end
  
   # t.integer  "product_id",              limit: 16, precision: 38
   #  t.integer  "product_list_id",         limit: 16, precision: 38
   #  t.string   "prod"
   #  t.string   "barcode"
   #  t.integer  "product_cost",            limit: 16, precision: 38
   #  t.integer  "basic_cost",              limit: 16, precision: 38
   #  t.integer  "shipping_handling",       limit: 16, precision: 38
   #  t.integer  "postage",                 limit: 16, precision: 38
   #  t.integer  "tel_cost",                limit: 16, precision: 38
   #  t.integer  "transf_order_basic",      limit: 16, precision: 38
   #  t.integer  "dealer_network_basic",    limit: 16, precision: 38
   #  t.integer  "wholesale_variable_cost", limit: 16, precision: 38
   #  t.integer  "royalty",                 limit: 16, precision: 38
   #  t.integer  "cost_of_return",          limit: 16, precision: 38
   #  t.integer  "call_centre_commission",  limit: 16, precision: 38
   #  t.datetime "created_at",                                        null: false
   #  t.datetime "updated_at",                                        null: false
   #  t.integer  "cost",                    limit: 16, precision: 38
   #  t.integer  "revenue",                 limit: 16, precision: 38
end
