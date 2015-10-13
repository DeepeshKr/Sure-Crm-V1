class DistributorStockLedgerTypesController < ApplicationController
  before_action :set_distributor_stock_ledger_type, only: [:show, :edit, :update, :destroy]

  # GET /distributor_stock_ledger_types
  # GET /distributor_stock_ledger_types.json
  def index
    @distributor_stock_ledger_types = DistributorStockLedgerType.all
  end

  # GET /distributor_stock_ledger_types/1
  # GET /distributor_stock_ledger_types/1.json
  def show
  end

  # GET /distributor_stock_ledger_types/new
  def new
    @distributor_stock_ledger_type = DistributorStockLedgerType.new
  end

  # GET /distributor_stock_ledger_types/1/edit
  def edit
  end

  # POST /distributor_stock_ledger_types
  # POST /distributor_stock_ledger_types.json
  def create
    @distributor_stock_ledger_type = DistributorStockLedgerType.new(distributor_stock_ledger_type_params)

    respond_to do |format|
      if @distributor_stock_ledger_type.save
        format.html { redirect_to @distributor_stock_ledger_type, notice: 'Distributor stock ledger type was successfully created.' }
        format.json { render :show, status: :created, location: @distributor_stock_ledger_type }
      else
        format.html { render :new }
        format.json { render json: @distributor_stock_ledger_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /distributor_stock_ledger_types/1
  # PATCH/PUT /distributor_stock_ledger_types/1.json
  def update
    respond_to do |format|
      if @distributor_stock_ledger_type.update(distributor_stock_ledger_type_params)
        format.html { redirect_to @distributor_stock_ledger_type, notice: 'Distributor stock ledger type was successfully updated.' }
        format.json { render :show, status: :ok, location: @distributor_stock_ledger_type }
      else
        format.html { render :edit }
        format.json { render json: @distributor_stock_ledger_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /distributor_stock_ledger_types/1
  # DELETE /distributor_stock_ledger_types/1.json
  def destroy
    @distributor_stock_ledger_type.destroy
    respond_to do |format|
      format.html { redirect_to distributor_stock_ledger_types_url, notice: 'Distributor stock ledger type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_distributor_stock_ledger_type
      @distributor_stock_ledger_type = DistributorStockLedgerType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def distributor_stock_ledger_type_params
      params.require(:distributor_stock_ledger_type).permit(:name, :sort_order, :description)
    end
end
