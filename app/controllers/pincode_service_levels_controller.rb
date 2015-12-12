class PincodeServiceLevelsController < ApplicationController
  before_action :set_pincode_service_level, only: [:show, :edit, :update, :destroy]

  # GET /pincode_service_levels
  # GET /pincode_service_levels.json
  def index
    @pincode_service_levels = PincodeServiceLevel.all
  end

  # GET /pincode_service_levels/1
  # GET /pincode_service_levels/1.json
  def show
  end

  # GET /pincode_service_levels/new
  def new
    @pincode_service_level = PincodeServiceLevel.new
  end

  # GET /pincode_service_levels/1/edit
  def edit
  end

  # POST /pincode_service_levels
  # POST /pincode_service_levels.json
  def create
    @pincode_service_level = PincodeServiceLevel.new(pincode_service_level_params)

    respond_to do |format|
      if @pincode_service_level.save
        format.html { redirect_to @pincode_service_level, notice: 'Pincode service level was successfully created.' }
        format.json { render :show, status: :created, location: @pincode_service_level }
      else
        format.html { render :new }
        format.json { render json: @pincode_service_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pincode_service_levels/1
  # PATCH/PUT /pincode_service_levels/1.json
  def update
    respond_to do |format|
      if @pincode_service_level.update(pincode_service_level_params)
        format.html { redirect_to @pincode_service_level, notice: 'Pincode service level was successfully updated.' }
        format.json { render :show, status: :ok, location: @pincode_service_level }
      else
        format.html { render :edit }
        format.json { render json: @pincode_service_level.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pincode_service_levels/1
  # DELETE /pincode_service_levels/1.json
  def destroy
    @pincode_service_level.destroy
    respond_to do |format|
      format.html { redirect_to pincode_service_levels_url, notice: 'Pincode service level was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pincode_service_level
      @pincode_service_level = PincodeServiceLevel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pincode_service_level_params
      params.require(:pincode_service_level).permit(:pincode, :total_orders, :total_value, :last_ran_on, :description, :courier_id, :time_to_deliver, :cod_avail, :distributor_avail, :paid_order, :paid_value)
    end
end
