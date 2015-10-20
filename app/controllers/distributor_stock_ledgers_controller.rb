class DistributorStockLedgersController < ApplicationController
  before_action :set_distributor_stock_ledger, only: [:show, :edit, :update, :destroy]

  # GET /distributor_stock_ledgers
  # GET /distributor_stock_ledgers.json
  def index
    @distributor_stock_ledgers = DistributorStockLedger.all
  end

  # GET /distributor_stock_ledgers/1
  # GET /distributor_stock_ledgers/1.json
  def show
  end

  # GET /distributor_stock_ledgers/new
  def new
    @product_master = ProductMaster.where(productactivecodeid: 10000) #.limit(10).order('name')
    @product_list = ProductList.joins(:product_variant).where("product_variants.activeid = 10000") #.limit(10).order('name')
    @distributor_stock_ledger_type = DistributorStockLedgerType.order('sort_order')
    @distributor_stock_ledger = DistributorStockLedger.new
  end

  # GET /distributor_stock_ledgers/1/edit
  def edit
  end

  # POST /distributor_stock_ledgers
  # POST /distributor_stock_ledgers.json
  def create
    #on create change update stock summary
    @distributor_stock_ledger = DistributorStockLedger.new(distributor_stock_ledger_params)

    respond_to do |format|
      if @distributor_stock_ledger.save

        #update_product_details(@distributor_stock_ledger.id)

        format.html { redirect_to corporate_path @distributor_stock_ledger.corporate_id, notice: 'Distributor stock ledger was successfully created.' }
        format.json { render :show, status: :created, location: @distributor_stock_ledger }
      else
        format.html { render :new }
        format.json { render json: @distributor_stock_ledger.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /distributor_stock_ledgers/1
  # PATCH/PUT /distributor_stock_ledgers/1.json
  def update
    #on create change update stock summary
    respond_to do |format|
      if @distributor_stock_ledger.update(distributor_stock_ledger_params)
        format.html { redirect_to corporate_path @distributor_stock_ledger.corporate_id, notice: 'Distributor stock ledger was successfully updated.' }
        format.json { render :show, status: :ok, location: @distributor_stock_ledger }
      else
        format.html { render :edit }
        format.json { render json: @distributor_stock_ledger.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /distributor_stock_ledgers/1
  # DELETE /distributor_stock_ledgers/1.json
  def destroy
    @distributor_stock_ledger.destroy
    respond_to do |format|
      format.html { redirect_to corporate_path @distributor_stock_ledger.corporate_id, notice: 'Distributor stock ledger was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_distributor_stock_ledger
      @distributor_stock_ledger = DistributorStockLedger.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def distributor_stock_ledger_params
      params.require(:distributor_stock_ledger).permit(:corporate_id, 
        :product_master_id, 
        :product_variant_id, 
        :product_list_id, :prod, :name, 
        :description, :stock_change, :stock_value, :ledger_date,
        :type_id)
    end
    def update_product_details(distributor_stock_ledger_id)
       distributor_stock_ledger = DistributorStockLedger.find(distributor_stock_ledger_id)
    if distributor_stock_ledger.product_list_id.present?
      #product list details from product master id
      product_list = ProductList.find(distributor_stock_ledger.product_list_id) #.joins(:product_variant).where("product_variants.activeid = 10000")
      if product_list.present?
        #product list details from product master id
        #distributor_stock_ledger = DistributorStockLedger.find(self.id)

        distributor_stock_ledger.update(product_master_id: product_list.product_master_id,
          product_variant_id: product_list.product_variant_id,
          prod: product_list.extproductcode)
        #product variant details from product master id
        if distributor_stock_ledger.type_id != 10000
          update_product_stock_summary(distributor_stock_ledger_id)
        end
        
      end
    end
  end

    def update_product_stock_summary(distributor_stock_ledger_id)
      distributor_stock_ledger = DistributorStockLedger.find(distributor_stock_ledger_id)
    todaydate = (330.minutes).from_now.to_date
    if distributor_stock_ledger.type_id != 10000
      if distributor_stock_ledger.product_list_id.present?
        #product list details from product master id
        product_list = ProductList.find(distributor_stock_ledger.product_list_id) #.joins(:product_variant).where("product_variants.activeid = 10000")
        if product_list.present?
          #product list details from product master id
           if DistributorStockSummary.where("product_list_id = ? and corporate_id = ?",distributor_stock_ledger.product_list_id, distributor_stock_ledger.corporate_id).present?
            
             distributor_stock_summary = DistributorStockSummary.where("product_list_id = ? and corporate_id = ?",distributor_stock_ledger.product_list_id, distributor_stock_ledger.corporate_id).first
          #   #get current balance
             balance_qty = distributor_stock_summary.stock_qty
             balance_val = distributor_stock_summary.stock_value
          #   #if self.type_id == 10001 #Add
             balance_qty += distributor_stock_ledger.stock_change
             balance_val += distributor_stock_ledger.stock_value
          #   #elsif self.type_id == 10002 #Remove
          #   # balance -= self.stock_change
          #   #end

             distributor_stock_summary.update(product_master_id: product_list.product_master_id,
             product_variant_id: product_list.product_variant_id,
             prod: product_list.extproductcode, 
             summary_date: distributor_stock_ledger.ledger_date,
             stock_qty: balance_qty, stock_value: balance_val)

           else
            
            DistributorStockSummary.create(product_list_id: distributor_stock_ledger.product_list_id,
            product_variant_id: distributor_stock_ledger.product_variant_id,
            product_master_id: distributor_stock_ledger.product_master_id,
            prod: distributor_stock_ledger.prod, 
            corporate_id: distributor_stock_ledger.corporate_id,
            summary_date: distributor_stock_ledger.ledger_date, 
            stock_qty: distributor_stock_ledger.stock_change,
            stock_value: distributor_stock_ledger.stock_value,
            stock_returned: 0)

          end
        end
      end
    end
  end
end
