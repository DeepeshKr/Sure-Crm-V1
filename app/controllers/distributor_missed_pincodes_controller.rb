class DistributorMissedPincodesController < ApplicationController
  before_action :set_distributor_missed_pincode, only: [:show, :edit, :update, :destroy]

  # GET /distributor_missed_pincodes
  # GET /distributor_missed_pincodes.json
  def index
      @order_sort = "high"
      @btn_class = "btn btn-primary btn-xs"
    if params.has_key?(:pincode)
      @pincode = params[:pincode]
        @distributor_missed_pincodes = DistributorMissedPincode.where(pincode: @pincode).order("total_value DESC").paginate(:page => params[:page])
    elsif params.has_key?(:high_order)
      if params[:high_order] == "high"
        @distributor_missed_pincodes = DistributorMissedPincode.order("total_value DESC").paginate(:page => params[:page])
        @order_sort = "low"
        @btn_class = "btn btn-info btn-xs"
      elsif params[:high_order] == "low"
        @distributor_missed_pincodes = DistributorMissedPincode.order("total_value ASC").paginate(:page => params[:page])
        @order_sort = "high"
        @btn_class = "btn btn-success btn-xs"
      end
    elsif params.has_key?(:recent)
      @distributor_missed_pincodes = DistributorMissedPincode.order("id DESC").paginate(:page => params[:page])
      @order_sort = "high"
      @btn_class = "btn btn-primary btn-xs"
    else
        @distributor_missed_pincodes = DistributorMissedPincode.order("updated_at DESC").paginate(:page => params[:page])
    end

  end

  # GET /distributor_missed_pincodes/1
  # GET /distributor_missed_pincodes/1.json
  def show
  end

  # GET /distributor_missed_pincodes/new
  def new
    @distributor_missed_pincode = DistributorMissedPincode.new
  end

  # GET /distributor_missed_pincodes/1/edit
  def edit
  end

  # POST /distributor_missed_pincodes
  # POST /distributor_missed_pincodes.json
  def create
    @distributor_missed_pincode = DistributorMissedPincode.new(distributor_missed_pincode_params)

    respond_to do |format|
      if @distributor_missed_pincode.save
        format.html { redirect_to @distributor_missed_pincode, notice: 'Distributor missed pincode was successfully created.' }
        format.json { render :show, status: :created, location: @distributor_missed_pincode }
      else
        format.html { render :new }
        format.json { render json: @distributor_missed_pincode.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /distributor_missed_pincodes/1
  # PATCH/PUT /distributor_missed_pincodes/1.json
  def update
    respond_to do |format|
      if @distributor_missed_pincode.update(distributor_missed_pincode_params)
        format.html { redirect_to @distributor_missed_pincode, notice: 'Distributor missed pincode was successfully updated.' }
        format.json { render :show, status: :ok, location: @distributor_missed_pincode }
      else
        format.html { render :edit }
        format.json { render json: @distributor_missed_pincode.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /distributor_missed_pincodes/1
  # DELETE /distributor_missed_pincodes/1.json
  def destroy
    @distributor_missed_pincode.destroy
    respond_to do |format|
      format.html { redirect_to distributor_missed_pincodes_url, notice: 'Distributor missed pincode was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_distributor_missed_pincode
      @distributor_missed_pincode = DistributorMissedPincode.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def distributor_missed_pincode_params
      params.require(:distributor_missed_pincode).permit(:pincode, :no_of_orders, :total_value, :last_ran_on, :description)
    end
end
