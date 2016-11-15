class OrderDispatchStatusesController < ApplicationController
  before_action :set_order_dispatch_status, only: [:show, :edit, :update, :destroy]

  # GET /order_dispatch_statuses
  # GET /order_dispatch_statuses.json
  def index
    @order_dispatch_statuses = OrderDispatchStatus.all
  end

  # GET /order_dispatch_statuses/1
  # GET /order_dispatch_statuses/1.json
  def show
  end

  # GET /order_dispatch_statuses/new
  def new
    @order_dispatch_status = OrderDispatchStatus.new
  end

  # GET /order_dispatch_statuses/1/edit
  def edit
  end

  # POST /order_dispatch_statuses
  # POST /order_dispatch_statuses.json
  def create
    @order_dispatch_status = OrderDispatchStatus.new(order_dispatch_status_params)

    respond_to do |format|
      if @order_dispatch_status.save
        format.html { redirect_to @order_dispatch_status, notice: 'Order dispatch status was successfully created.' }
        format.json { render :show, status: :created, location: @order_dispatch_status }
      else
        format.html { render :new }
        format.json { render json: @order_dispatch_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /order_dispatch_statuses/1
  # PATCH/PUT /order_dispatch_statuses/1.json
  def update
    respond_to do |format|
      if @order_dispatch_status.update(order_dispatch_status_params)
        format.html { redirect_to @order_dispatch_status, notice: 'Order dispatch status was successfully updated.' }
        format.json { render :show, status: :ok, location: @order_dispatch_status }
      else
        format.html { render :edit }
        format.json { render json: @order_dispatch_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /order_dispatch_statuses/1
  # DELETE /order_dispatch_statuses/1.json
  def destroy
    @order_dispatch_status.destroy
    respond_to do |format|
      format.html { redirect_to order_dispatch_statuses_url, notice: 'Order dispatch status was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order_dispatch_status
      @order_dispatch_status = OrderDispatchStatus.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_dispatch_status_params
      params.require(:order_dispatch_status).permit(:name, :description, :sort_order)
    end
end
