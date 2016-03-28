class ReturnRatesController < ApplicationController
  before_action { protect_controllers(5) }
  before_action :set_return_rate, only: [:show, :edit, :update, :destroy]

  # GET /return_rates
  # GET /return_rates.json
  def index
    @return_rates_0 = ReturnRate.where("media_id is null and product_list_id is null").order(:no_of_days).where(offset: 0)
    @return_rates_30 = ReturnRate.where("media_id is null and product_list_id is null").order(:no_of_days).where(offset: 30)
    @return_rates_60 = ReturnRate.where("media_id is null and product_list_id is null").order(:no_of_days).where(offset: 60)
  end

  # GET /return_rates/1
  # GET /return_rates/1.json
  def show
  end

  

 
  # DELETE /return_rates/1
  # DELETE /return_rates/1.json
  def destroy
    @return_rate.destroy
    respond_to do |format|
      format.html { redirect_to return_rates_url, notice: 'Return rate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_return_rate
      @return_rate = ReturnRate.find(params[:id])
    end
    # t.integer  "shipped",            precision: 38
    # t.integer  "offset",             precision: 38
    # t.integer  "media_id",           precision: 38
    # t.integer  "product_master_id",  precision: 38
    # t.integer  "product_variant_id", precision: 38
    # t.integer  "product_list_id",    precision: 38
    # t.string   "ext_prod_code"
    # Never trust parameters from the scary internet, only allow the white list through.
    def return_rate_params
      params.require(:return_rate).permit(:name, :sort_order, :total, :cancelled, :returned, :paid, :transfer_total, :transfer_paid, :transfer_cancelled, :no_of_days, :shipped, :offset, :media_id,
      :product_master_id, :product_variant_id, :product_list_id, :ext_prod_code)
    end
end
