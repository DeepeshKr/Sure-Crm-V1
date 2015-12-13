class FedexBillChecksController < ApplicationController
  require 'roo'
  before_action :set_fedex_bill_check, only: [:show, :edit, :update, :destroy]
  #

  # GET /fedex_bill_checks
  # GET /fedex_bill_checks.json
  def index
    @list_of_uploads = FedexBillCheck.select("verif_name as reference, count(verif_name) as records").group("verif_name").limit(10)
    @show_csv = "false"
    @fedex_bill_checks = FedexBillCheck.paginate(:page => params[:page])
    if params.has_key?(:ref_name)
        @fedex_bill_checks = FedexBillCheck.where(verif_name: params[:ref_name]).paginate(:page => params[:page])
        @show_csv = params[:ref_name]
    end
  end

  # GET /fedex_bill_checks/download
  def download
    if params.has_key?(:ref_name)
        ref_name = params[:ref_name]
        respond_to do |format|
          format.csv do
            @fedex_bill_checks = FedexBillCheck.where(verif_name: ref_name)
                  headers['Content-Disposition'] = "attachment; filename=\"#{ref_name}fedex-bill-check.csv\""
                  headers['Content-Type'] ||= 'text/csv'
          end
        end
      else

    end
  end
  # GET /fedex_bill_checks/1
  # GET /fedex_bill_checks/1.json
  def show
  end

  # GET /fedex_bill_checks/import
  def import
    FedexBillCheck.import(params[:file], params[:ref_name])
    redirect_to fedex_bill_checks_path(ref_name: params[:ref_name]), notice: "File imported."
  end

  # GET /fedex_bill_checks/new
  def new
    @fedex_bill_check = FedexBillCheck.new
  end

  # GET /fedex_bill_checks/1/edit
  def edit
  end

  # POST /fedex_bill_checks
  # POST /fedex_bill_checks.json
  def create
    @fedex_bill_check = FedexBillCheck.new(fedex_bill_check_params)

    respond_to do |format|
      if @fedex_bill_check.save
        format.html { redirect_to @fedex_bill_check, notice: 'Fedex bill check was successfully created.' }
        format.json { render :show, status: :created, location: @fedex_bill_check }
      else
        format.html { render :new }
        format.json { render json: @fedex_bill_check.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fedex_bill_checks/1
  # PATCH/PUT /fedex_bill_checks/1.json
  def update
    respond_to do |format|
      if @fedex_bill_check.update(fedex_bill_check_params)
        format.html { redirect_to @fedex_bill_check, notice: 'Fedex bill check was successfully updated.' }
        format.json { render :show, status: :ok, location: @fedex_bill_check }
      else
        format.html { render :edit }
        format.json { render json: @fedex_bill_check.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete
    if params.has_key?(:ref_name)
      records = 0
      ref_name =params[:ref_name]
        fedex_bill_checks = FedexBillCheck.where(verif_name: ref_name)
        fedex_bill_checks.each do |fedex|
          fedex.destroy
          records += 1
        end
        flash[:success] = '#{records} Fedex bills with reference name #{ref_name} was successfully destroyed.'
          redirect_to fedex_bill_checks_url
    end
  end
  # DELETE /fedex_bill_checks/1
  # DELETE /fedex_bill_checks/1.json
  def destroy

      @fedex_bill_check.destroy
      respond_to do |format|
        format.html { redirect_to fedex_bill_checks_url, notice: 'Fedex bill check was successfully destroyed.' }
        format.json { head :no_content }
      end

  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fedex_bill_check
      @fedex_bill_check = FedexBillCheck.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fedex_bill_check_params
      params.require(:fedex_bill_check).permit(:shp_cust_nbr, :acctno, :invno, :invdate, :awb, :shipdate, :shprname, :coname, :shipadd, :shprlocation, :shp_postal_code, :shipreference, :origloc, :origctry, :destloc, :destctry, :svc1, :pcs, :weight, :dimwgt, :wgttype, :dimflag, :billflag, :ratedamt, :discount, :address_correction, :cod_fee, :freight_on_value_carriers_risk, :freight_on_value_own_risk, :fuel_surcharge, :higher_floor_delivery, :india_service_tax, :out_of_delivery_area, :billedamt, :recp_pstl_cd, :verif_name, :verif_order_ref_id, :verif_order_no, :verif_products, :verif_weight, :verif_weight_diff, :verif_comments, :verif_basic, :verif_fuel_surcharge, :verif_cod, :verif_service_tax, :verif_total_charges, :verif_upload_date )
    end
end
