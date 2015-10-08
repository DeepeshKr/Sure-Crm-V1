class DistributorStockSummariesController < ApplicationController
  before_action :set_distributor_stock_summary, only: [:show, :edit, :update, :destroy]

  # GET /distributor_stock_summaries
  # GET /distributor_stock_summaries.json
  def index
    @distributor_stock_summaries = DistributorStockSummary.all
  end

  # GET /distributor_stock_summaries/1
  # GET /distributor_stock_summaries/1.json
  def show
  end

  # GET /distributor_stock_summaries/new
  def new
    @distributor_stock_summary = DistributorStockSummary.new
  end

  # GET /distributor_stock_summaries/1/edit
  def edit
  end

  # POST /distributor_stock_summaries
  # POST /distributor_stock_summaries.json
  def create
    @distributor_stock_summary = DistributorStockSummary.new(distributor_stock_summary_params)

    respond_to do |format|
      if @distributor_stock_summary.save
        format.html { redirect_to @distributor_stock_summary, notice: 'Distributor stock summary was successfully created.' }
        format.json { render :show, status: :created, location: @distributor_stock_summary }
      else
        format.html { render :new }
        format.json { render json: @distributor_stock_summary.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /distributor_stock_summaries/1
  # PATCH/PUT /distributor_stock_summaries/1.json
  def update
    respond_to do |format|
      if @distributor_stock_summary.update(distributor_stock_summary_params)
        format.html { redirect_to @distributor_stock_summary, notice: 'Distributor stock summary was successfully updated.' }
        format.json { render :show, status: :ok, location: @distributor_stock_summary }
      else
        format.html { render :edit }
        format.json { render json: @distributor_stock_summary.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /distributor_stock_summaries/1
  # DELETE /distributor_stock_summaries/1.json
  def destroy
    @distributor_stock_summary.destroy
    respond_to do |format|
      format.html { redirect_to distributor_stock_summaries_url, notice: 'Distributor stock summary was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_distributor_stock_summary
      @distributor_stock_summary = DistributorStockSummary.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def distributor_stock_summary_params
      params.require(:distributor_stock_summary).permit(:corporate_id, :product_master_id, :product_variant_id, :product_list_id, :prod, :stock_balance, :rupee_balance, :stock_returned, :summary_date)
    end
end
