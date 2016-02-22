class CableOpertorCommsController < ApplicationController
  before_action :set_cable_opertor_comm, only: [:show, :edit, :update, :destroy]

  # GET /cable_opertor_comms
  # GET /cable_opertor_comms.json
  def index
    @cable_opertor_comms = CableOpertorComm.all
  end

  # GET /cable_opertor_comms/1
  # GET /cable_opertor_comms/1.json
  def show
  end

  # GET /cable_opertor_comms/new
  def new
    @cable_opertor_comm = CableOpertorComm.new
  end

  # GET /cable_opertor_comms/1/edit
  def edit
  end

  # POST /cable_opertor_comms
  # POST /cable_opertor_comms.json
  def create
    @cable_opertor_comm = CableOpertorComm.new(cable_opertor_comm_params)

    respond_to do |format|
      if @cable_opertor_comm.save
        format.html { redirect_to @cable_opertor_comm, notice: 'Cable opertor comm was successfully created.' }
        format.json { render :show, status: :created, location: @cable_opertor_comm }
      else
        format.html { render :new }
        format.json { render json: @cable_opertor_comm.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cable_opertor_comms/1
  # PATCH/PUT /cable_opertor_comms/1.json
  def update
    respond_to do |format|
      if @cable_opertor_comm.update(cable_opertor_comm_params)
        format.html { redirect_to @cable_opertor_comm, notice: 'Cable opertor comm was successfully updated.' }
        format.json { render :show, status: :ok, location: @cable_opertor_comm }
      else
        format.html { render :edit }
        format.json { render json: @cable_opertor_comm.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cable_opertor_comms/1
  # DELETE /cable_opertor_comms/1.json
  def destroy
    @cable_opertor_comm.destroy
    respond_to do |format|
      format.html { redirect_to cable_opertor_comms_url, notice: 'Cable opertor comm was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cable_opertor_comm
      @cable_opertor_comm = CableOpertorComm.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cable_opertor_comm_params
      params.require(:cable_opertor_comm).permit(:order_no, :order_date, :channel, :product, :amount, :customer_name, :city, :comm, :description)
    end
end
