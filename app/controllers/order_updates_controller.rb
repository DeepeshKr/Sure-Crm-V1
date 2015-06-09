class OrderUpdatesController < ApplicationController
  before_action :set_order_update, only: [:show, :edit, :update, :destroy]

  # GET /order_updates
  # GET /order_updates.json
  def index
    @order_updates = OrderUpdate.all
  end

  # GET /order_updates/1
  # GET /order_updates/1.json
  def show
  end

  # GET /order_updates/new
  def new
    @order_update = OrderUpdate.new
  end

  # GET /order_updates/1/edit
  def edit
  end

  # POST /order_updates
  # POST /order_updates.json
  def create
    @order_update = OrderUpdate.new(order_update_params)

    respond_to do |format|
      if @order_update.save
        format.html { redirect_to @order_update, notice: 'Order update was successfully created.' }
        format.json { render :show, status: :created, location: @order_update }
      else
        format.html { render :new }
        format.json { render json: @order_update.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /order_updates/1
  # PATCH/PUT /order_updates/1.json
  def update
    respond_to do |format|
      if @order_update.update(order_update_params)
        format.html { redirect_to @order_update, notice: 'Order update was successfully updated.' }
        format.json { render :show, status: :ok, location: @order_update }
      else
        format.html { render :edit }
        format.json { render json: @order_update.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /order_updates/1
  # DELETE /order_updates/1.json
  def destroy
    @order_update.destroy
    respond_to do |format|
      format.html { redirect_to order_updates_url, notice: 'Order update was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order_update
      @order_update = OrderUpdate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_update_params
      params.require(:order_update).permit(:order_id, :orderno, :order_date, :process_date, :shipped_date, :return_date, :cancel_date, :paid_date)
    end
end
