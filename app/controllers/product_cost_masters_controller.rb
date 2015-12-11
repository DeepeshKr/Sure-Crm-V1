class ProductCostMastersController < ApplicationController

  before_action :set_product_cost_master, only: [:show, :edit, :update, :destroy]
  before_action { protect_controllers(5) }
  # GET /product_cost_masters
  # GET /product_cost_masters.json
  def index

    @product_cost_masters = ProductCostMaster.all.paginate(:page => params[:page])
    #update_all
    #reset_prices

    respond_to do |format|
      format.csv do
        @product_cost_masters = ProductCostMaster.all
              headers['Content-Disposition'] = "attachment; filename=\"product-costs\""
              headers['Content-Type'] ||= 'text/csv'
      end
    end
  end

  def product_costs
    @showall = true
    #reset_prices
    @all_product_cost_masters = ProductCostMaster.where("product_list_id IS NOT NULL").pluck(:product_list_id)

    @all_product_cost_masters_prod = ProductCostMaster.where("prod IS NOT NULL").pluck(:prod)

    @all_product_variant_prod = ProductVariant.where("extproductcode IS NOT NULL").pluck(:extproductcode)

    @all_product_master_prod = ProductMaster.where("extproductcode IS NOT NULL").pluck(:extproductcode)

      # @product_cost_masters = ProductCostMaster.where("product_list_id IS NOT NULL").pluck(:product_list_id)
    if params.has_key?(:search)
      @search = "Search for " +  params[:search].upcase
      @searchvalue = params[:search].upcase

      # @product_lists = ProductList.where(id: @product_cost_masters).where("name like ? OR extproductcode like ? or list_barcode like ?", "#{@searchvalue}%",
      #   "#{@searchvalue}%", "#{@searchvalue}%")
      # .paginate(:page => params[:page])

      @product_cost_masters = ProductCostMaster.all.where("prod like ? OR barcode like ?", "#{@searchvalue}%", "#{@searchvalue}%").paginate(:page => params[:page])

      @inactive_product_lists = ProductList.where('id NOT IN (?)', @all_product_cost_masters)
      .where("name like ? OR extproductcode like ? or list_barcode like ?",
        "#{@searchvalue}%", "#{@searchvalue}%", "#{@searchvalue}%")
      .paginate(:page => params[:page])

      @inactive_product_variants = ProductVariant.where('extproductcode NOT IN (?)', @all_product_cost_masters_prod).where("name like ? OR extproductcode like ?", "#{@searchvalue}%", "#{@searchvalue}%")

      @found = @product_cost_masters.count

      else
        @search = "Product Sell List"
        @searchvalue = nil

        @product_cost_masters = ProductCostMaster.all.paginate(:page => params[:page])

        @nos_with_price = @product_cost_masters.count()

        @inactive_product_lists = ProductList.where('id NOT IN (?)',   @all_product_cost_masters).order('updated_at DESC').paginate(:page => params[:page])
        #.where('active_status_id = ?',  10000)
        @nos_with_out_price = @inactive_product_lists.count()
        @found = nil

    end
        # format.csv do
        #     headers['Content-Disposition'] = "attachment; filename=\"product-costs\""
        #     headers['Content-Type'] ||= 'text/csv'
        # end

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
  # GET /product_cost_masters/1
  # GET /product_cost_masters/1.json
  def show
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
        :call_centre_commission => 0)
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_cost_master_params
      params.require(:product_cost_master).permit(:product_id, :product_list_id,
        :prod, :barcode, :product_cost, :basic_cost,
        :shipping_handling, :postage,
        :tel_cost, :transf_order_basic,
        :dealer_network_basic,
        :wholesale_variable_cost,
        :royalty, :cost_of_return, :call_centre_commission)
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
