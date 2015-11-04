class DistributorMissedOrderTypesController < ApplicationController
  before_action :set_distributor_missed_order_type, only: [:show, :edit, :update, :destroy]

  # GET /distributor_missed_order_types
  # GET /distributor_missed_order_types.json
  def index
    @distributor_missed_order_types = DistributorMissedOrderType.all
  end

  # GET /distributor_missed_order_types/1
  # GET /distributor_missed_order_types/1.json
  def show
  end

  # GET /distributor_missed_order_types/new
  def new
    @distributor_missed_order_type = DistributorMissedOrderType.new
  end

  # GET /distributor_missed_order_types/1/edit
  def edit
  end

  # POST /distributor_missed_order_types
  # POST /distributor_missed_order_types.json
  def create
    @distributor_missed_order_type = DistributorMissedOrderType.new(distributor_missed_order_type_params)

    respond_to do |format|
      if @distributor_missed_order_type.save
        format.html { redirect_to @distributor_missed_order_type, notice: 'Distributor missed order type was successfully created.' }
        format.json { render :show, status: :created, location: @distributor_missed_order_type }
      else
        format.html { render :new }
        format.json { render json: @distributor_missed_order_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /distributor_missed_order_types/1
  # PATCH/PUT /distributor_missed_order_types/1.json
  def update
    respond_to do |format|
      if @distributor_missed_order_type.update(distributor_missed_order_type_params)
        format.html { redirect_to @distributor_missed_order_type, notice: 'Distributor missed order type was successfully updated.' }
        format.json { render :show, status: :ok, location: @distributor_missed_order_type }
      else
        format.html { render :edit }
        format.json { render json: @distributor_missed_order_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /distributor_missed_order_types/1
  # DELETE /distributor_missed_order_types/1.json
  def destroy
    @distributor_missed_order_type.destroy
    respond_to do |format|
      format.html { redirect_to distributor_missed_order_types_url, notice: 'Distributor missed order type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_distributor_missed_order_type
      @distributor_missed_order_type = DistributorMissedOrderType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def distributor_missed_order_type_params
      params.require(:distributor_missed_order_type).permit(:name, :sort_order, :description)
    end
end
