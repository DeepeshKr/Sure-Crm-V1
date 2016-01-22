class TransferOrderStatusesController < ApplicationController
  before_action :set_transfer_order_status, only: [:show, :edit, :update, :destroy]

  # GET /transfer_order_statuses
  # GET /transfer_order_statuses.json
  def index
    @transfer_order_statuses = TransferOrderStatus.all
  end

  # GET /transfer_order_statuses/1
  # GET /transfer_order_statuses/1.json
  def show
  end

  # GET /transfer_order_statuses/new
  def new
    @transfer_order_status = TransferOrderStatus.new
  end

  # GET /transfer_order_statuses/1/edit
  def edit
  end

  # POST /transfer_order_statuses
  # POST /transfer_order_statuses.json
  def create
    @transfer_order_status = TransferOrderStatus.new(transfer_order_status_params)

    respond_to do |format|
      if @transfer_order_status.save
        format.html { redirect_to @transfer_order_status, notice: 'Transfer order status was successfully created.' }
        format.json { render :show, status: :created, location: @transfer_order_status }
      else
        format.html { render :new }
        format.json { render json: @transfer_order_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transfer_order_statuses/1
  # PATCH/PUT /transfer_order_statuses/1.json
  def update
    respond_to do |format|
      if @transfer_order_status.update(transfer_order_status_params)
        format.html { redirect_to @transfer_order_status, notice: 'Transfer order status was successfully updated.' }
        format.json { render :show, status: :ok, location: @transfer_order_status }
      else
        format.html { render :edit }
        format.json { render json: @transfer_order_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transfer_order_statuses/1
  # DELETE /transfer_order_statuses/1.json
  def destroy
    @transfer_order_status.destroy
    respond_to do |format|
      format.html { redirect_to transfer_order_statuses_url, notice: 'Transfer order status was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transfer_order_status
      @transfer_order_status = TransferOrderStatus.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transfer_order_status_params
      params.require(:transfer_order_status).permit(:name, :sort_order, :description)
    end
end
