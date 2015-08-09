class ProductCostMastersController < ApplicationController
  before_action :set_product_cost_master, only: [:show, :edit, :update, :destroy]

  # GET /product_cost_masters
  # GET /product_cost_masters.json
  def index
    @product_cost_masters = ProductCostMaster.all.paginate(:page => params[:page])
    #update_all
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
      product_list_id: product_list_id, product_id: product_id)
  end

  # GET /product_cost_masters/1/edit
  def edit
  end

  # POST /product_cost_masters
  # POST /product_cost_masters.json
  def create

    @product_cost_master = ProductCostMaster.new(product_cost_master_params)

    respond_to do |format|
      if @product_cost_master.save
        format.html { redirect_to @product_cost_master, notice: 'Product cost master was successfully created.' }
        format.json { render :show, status: :created, location: @product_cost_master }
      else
        format.html { render :new }
        format.json { render json: @product_cost_master.errors, status: :unprocessable_entity }
      end
    end
    redirect_to productwithcosts_path
  end

  # PATCH/PUT /product_cost_masters/1
  # PATCH/PUT /product_cost_masters/1.json
  def update
    respond_to do |format|
      if @product_cost_master.update(product_cost_master_params)
        format.html { redirect_to @product_cost_master, notice: 'Product cost master was successfully updated.' }
        format.json { render :show, status: :ok, location: @product_cost_master }
      else
        format.html { render :edit }
        format.json { render json: @product_cost_master.errors, status: :unprocessable_entity }
      end
    end
    redirect_to productwithcosts_path
  end

  # DELETE /product_cost_masters/1
  # DELETE /product_cost_masters/1.json
  def destroy
    @product_cost_master.destroy
    respond_to do |format|
      format.html { redirect_to product_cost_masters_url, notice: 'Product cost master was successfully destroyed.' }
      format.json { head :no_content }
    end
    redirect_to productwithcosts_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_cost_master
      @product_cost_master = ProductCostMaster.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_cost_master_params
      params.require(:product_cost_master).permit(:product_id, :product_list_id, :prod, :barcode, :product_cost, :basic_cost, :shipping_handling, :postage, :tel_cost, :transf_order_basic, :dealer_network_basic, :wholesale_variable_cost, :royalty, :cost_of_return, :call_centre_commission)
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
