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
    @product_master = ProductMaster.where(productactivecodeid: 10000).limit(10).order('name')
     @distributor_stock_ledger_type = DistributorStockLedgerType.order('sort_order')
    @distributor_stock_ledger = DistributorStockLedger.new
  end

  # GET /distributor_stock_ledgers/1/edit
  def edit
  end

  # POST /distributor_stock_ledgers
  # POST /distributor_stock_ledgers.json
  def create
    @distributor_stock_ledger = DistributorStockLedger.new(distributor_stock_ledger_params)

    respond_to do |format|
      if @distributor_stock_ledger.save
        format.html { redirect_to @distributor_stock_ledger, notice: 'Distributor stock ledger was successfully created.' }
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
    respond_to do |format|
      if @distributor_stock_ledger.update(distributor_stock_ledger_params)
        format.html { redirect_to @distributor_stock_ledger, notice: 'Distributor stock ledger was successfully updated.' }
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
      format.html { redirect_to distributor_stock_ledgers_url, notice: 'Distributor stock ledger was successfully destroyed.' }
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
      params.require(:distributor_stock_ledger).permit(:corporate_id, :product_master_id, :product_variant_id, :product_list_id, :prod, :name, :description, :stock_change, :ledger_date)
    end
end
