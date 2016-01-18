class SalesPposController < ApplicationController
  before_action :set_sales_ppo, only: [:show, :edit, :update, :destroy]

  # GET /sales_ppos
  # GET /sales_ppos.json
  def index
    @sales_ppos = SalesPpo.all
  end

  # GET /sales_ppos/1
  # GET /sales_ppos/1.json
  def show
  end

  # GET /sales_ppos/new
  def new
    @sales_ppo = SalesPpo.new
  end

  # GET /sales_ppos/1/edit
  def edit
  end

  # POST /sales_ppos
  # POST /sales_ppos.json
  def create
    @sales_ppo = SalesPpo.new(sales_ppo_params)

    respond_to do |format|
      if @sales_ppo.save
        format.html { redirect_to @sales_ppo, notice: 'Sales ppo was successfully created.' }
        format.json { render :show, status: :created, location: @sales_ppo }
      else
        format.html { render :new }
        format.json { render json: @sales_ppo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sales_ppos/1
  # PATCH/PUT /sales_ppos/1.json
  def update
    respond_to do |format|
      if @sales_ppo.update(sales_ppo_params)
        format.html { redirect_to @sales_ppo, notice: 'Sales ppo was successfully updated.' }
        format.json { render :show, status: :ok, location: @sales_ppo }
      else
        format.html { render :edit }
        format.json { render json: @sales_ppo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales_ppos/1
  # DELETE /sales_ppos/1.json
  def destroy
    @sales_ppo.destroy
    respond_to do |format|
      format.html { redirect_to sales_ppos_url, notice: 'Sales ppo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sales_ppo
      @sales_ppo = SalesPpo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sales_ppo_params
      params.require(:sales_ppo).permit(:campaign_playlist_id, :campaign_id, :product_master_id, :product_variant_id, :product_list_id, :prod, :name, :start_time, :order_id, :order_line_id, :product_cost, :pieces, :revenue, :damages, :returns, :commission_cost, :promotion_cost, :media_cost, :gross_sales, :net_sale, :external_order_no, :order_status_id, :order_last_mile_id, :order_pincode, :media_id, :media_cost_total, :promo_cost_total, :dnis, :city, :state, :mobile_no)
    end
end
