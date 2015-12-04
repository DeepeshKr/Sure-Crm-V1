class DistributorUploadOrdersController < ApplicationController
  before_action :set_distributor_upload_order, only: [:show, :edit, :update, :destroy]

  # GET /distributor_upload_orders
  # GET /distributor_upload_orders.json
  def index
    @distributor_upload_orders = DistributorUploadOrder.all
  end

  # GET /distributor_upload_orders/1
  # GET /distributor_upload_orders/1.json
  def show
  end

  # GET /distributor_upload_orders/new
  def new
    @distributor_upload_order = DistributorUploadOrder.new
  end

  # GET /distributor_upload_orders/1/edit
  def edit
  end

  # POST /distributor_upload_orders
  # POST /distributor_upload_orders.json
  def create
    @distributor_upload_order = DistributorUploadOrder.new(distributor_upload_order_params)

    respond_to do |format|
      if @distributor_upload_order.save
        format.html { redirect_to @distributor_upload_order, notice: 'Distributor upload order was successfully created.' }
        format.json { render :show, status: :created, location: @distributor_upload_order }
      else
        format.html { render :new }
        format.json { render json: @distributor_upload_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /distributor_upload_orders/1
  # PATCH/PUT /distributor_upload_orders/1.json
  def update
    respond_to do |format|
      if @distributor_upload_order.update(distributor_upload_order_params)
        format.html { redirect_to @distributor_upload_order, notice: 'Distributor upload order was successfully updated.' }
        format.json { render :show, status: :ok, location: @distributor_upload_order }
      else
        format.html { render :edit }
        format.json { render json: @distributor_upload_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /distributor_upload_orders/1
  # DELETE /distributor_upload_orders/1.json
  def destroy
    @distributor_upload_order.destroy
    respond_to do |format|
      format.html { redirect_to distributor_upload_orders_url, notice: 'Distributor upload order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_distributor_upload_order
      @distributor_upload_order = DistributorUploadOrder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def distributor_upload_order_params
      params.require(:distributor_upload_order).permit(:order_id, :ext_order_id, :last_ran_on, :description, :online_order_id, :online_last_ran_on, :online_description)
    end
end
