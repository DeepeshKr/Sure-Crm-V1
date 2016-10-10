class SalesPpoProductAlertsController < ApplicationController
  before_action :set_sales_ppo_product_alert, only: [:show, :edit, :update, :destroy]

  # GET /sales_ppo_product_alerts
  # GET /sales_ppo_product_alerts.json
  def index
    @sales_ppo_product_alerts = SalesPpoProductAlert.all
  end

  # GET /sales_ppo_product_alerts/1
  # GET /sales_ppo_product_alerts/1.json
  def show
  end

  # GET /sales_ppo_product_alerts/new
  def new
    @sales_ppo_product_alert = SalesPpoProductAlert.new
  end

  # GET /sales_ppo_product_alerts/1/edit
  def edit
  end

  # POST /sales_ppo_product_alerts
  # POST /sales_ppo_product_alerts.json
  def create
    @sales_ppo_product_alert = SalesPpoProductAlert.new(sales_ppo_product_alert_params)

    respond_to do |format|
      if @sales_ppo_product_alert.save
        format.html { redirect_to sales_ppo_email_alerts_url, notice: 'Sales ppo product alert was successfully created.' }
        format.json { render :show, status: :created, location: @sales_ppo_product_alert }
      else
        format.html { redirect_to sales_ppo_email_alerts_url, error: @sales_ppo_product_alert.errors.full_messages }
        format.json { render json: @sales_ppo_product_alert.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sales_ppo_product_alerts/1
  # PATCH/PUT /sales_ppo_product_alerts/1.json
  def update
    respond_to do |format|
      if @sales_ppo_product_alert.update(sales_ppo_product_alert_params)
        format.html { redirect_to @sales_ppo_product_alert, notice: 'Sales ppo product alert was successfully updated.' }
        format.json { render :show, status: :ok, location: @sales_ppo_product_alert }
      else
        format.html { render :edit }
        format.json { render json: @sales_ppo_product_alert.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales_ppo_product_alerts/1
  # DELETE /sales_ppo_product_alerts/1.json
  def destroy
    @sales_ppo_product_alert.destroy
    respond_to do |format|
      format.html { redirect_to sales_ppo_email_alerts_url, notice: 'Sales ppo product alert was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sales_ppo_product_alert
      @sales_ppo_product_alert = SalesPpoProductAlert.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sales_ppo_product_alert_params
      params.require(:sales_ppo_product_alert).permit(:product_list_id)
    end
end
