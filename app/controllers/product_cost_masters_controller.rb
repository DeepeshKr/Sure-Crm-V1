class ProductCostMastersController < ApplicationController
  before_action :set_product_cost_master, only: [:show, :edit, :update, :destroy]

  # GET /product_cost_masters
  # GET /product_cost_masters.json
  def index
     if params.has_key?(:search)
      @prod = params[:search].upcase
      @product_cost_masters = ProductCostMaster.where("prod = ?", @prod)
    else

    
    @product_cost_masters = ProductCostMaster.all

    #update the entire list
    @ropmasters = ROPMASTER_NEW.all
    @ropmasters.each do |rop|

        #check if found earlier else add
      product_cost_master = ProductCostMaster.where(prod: rop.prod)
      if product_cost_master.blank?
        product_id = nil
        prod = ProductList.where(extproductcode: rop.prod).pluck(:product_master_id)
        if prod.present?
          product_id = prod.first
        end
        ProductCostMaster.create(product_id: product_id, 
        prod: rop.prod,  
        cost: rop.totalcost, 
        revenue: rop.totalrevenue)

      end
    end

     @ropmasterhbn = ROPMASTER_HBN.where("prod = ?", @prod)
     @ropmasterhbn.each do |rop|
         #check if found earlier else add
        product_cost_master = ProductCostMaster.where(prod: rop.prod)
        if product_cost_master.blank?

        product_id = nil
        prod = ProductList.where(extproductcode: rop.prod).pluck(:product_master_id)
        if prod.present?
          product_id = prod.first
        end
       
        ProductCostMaster.create(product_id: product_id, 
          prod: rop.prod,  
          cost: rop.totalcost, 
          revenue: rop.totalrevenue)
         end
      end

    @ropupsprod = ROPUPSPROD.where("prod = ?", @prod)
     
      @ropupsprod.each do |rop|
         #check if found earlier else add
        product_cost_master = ProductCostMaster.where(prod: rop.prod)
        if product_cost_master.blank?

        product_id = nil
        prod = ProductList.where(extproductcode: rop.prod).pluck(:product_master_id)
        if prod.present?
          product_id = prod.first
        end
       
        ProductCostMaster.create(product_id: product_id, 
          prod: rop.prod,  
          cost: rop.cost)
         end
      end

     
    end
  end

  # GET /product_cost_masters/1
  # GET /product_cost_masters/1.json
  def show
     
  end

  # GET /product_cost_masters/new
  def new
    @product_cost_master = ProductCostMaster.new
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
  end

  # DELETE /product_cost_masters/1
  # DELETE /product_cost_masters/1.json
  def destroy
    @product_cost_master.destroy
    respond_to do |format|
      format.html { redirect_to product_cost_masters_url, notice: 'Product cost master was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_cost_master
      @product_cost_master = ProductCostMaster.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_cost_master_params
      params.require(:product_cost_master).permit(:product_id, :prod, :barcode, 
        :cost, :revenue)
    end
end
