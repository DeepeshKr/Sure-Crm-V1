class TransferOrderMastersController < ApplicationController
  before_action :set_transfer_order_master, only: [:show, :edit, :update, :destroy]

  # GET /transfer_order_masters
  # GET /transfer_order_masters.json
  def index
    @transfer_order_masters = TransferOrderMaster.all
  end

  # GET /transfer_order_masters/1
  # GET /transfer_order_masters/1.json
  def show
  end

  # GET /transfer_order_masters/new
  def new
    @transfer_order_master = TransferOrderMaster.new
  end

  # GET /transfer_order_masters/1/edit
  def edit
  end

  # POST /transfer_order_masters
  # POST /transfer_order_masters.json
  def create
    @transfer_order_master = TransferOrderMaster.new(transfer_order_master_params)

    respond_to do |format|
      if @transfer_order_master.save
        format.html { redirect_to @transfer_order_master, notice: 'Transfer order master was successfully created.' }
        format.json { render :show, status: :created, location: @transfer_order_master }
      else
        format.html { render :new }
        format.json { render json: @transfer_order_master.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transfer_order_masters/1
  # PATCH/PUT /transfer_order_masters/1.json
  def update
    respond_to do |format|
      if @transfer_order_master.update(transfer_order_master_params)
        format.html { redirect_to @transfer_order_master, notice: 'Transfer order master was successfully updated.' }
        format.json { render :show, status: :ok, location: @transfer_order_master }
      else
        format.html { render :edit }
        format.json { render json: @transfer_order_master.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transfer_order_masters/1
  # DELETE /transfer_order_masters/1.json
  def destroy
    @transfer_order_master.destroy
    respond_to do |format|
      format.html { redirect_to transfer_order_masters_url, notice: 'Transfer order master was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transfer_order_master
      @transfer_order_master = TransferOrderMaster.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transfer_order_master_params
      params.require(:transfer_order_master).permit(:corporate_id, :orderdate, :customer_id, :order_id, :order_no, :customer_name, :mobile, :email, :address1, :address2, :address3, :landmark, :district, :city, :state, :country, :pincode, :phone1, :phone2, :pieces, :sub_total, :shipping, :codcharges, :total, :g_total, :transfer_order_status_id, :notes)
    end
end
