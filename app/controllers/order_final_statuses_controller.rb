class OrderFinalStatusesController < ApplicationController
  before_action :set_order_final_status, only: [:show, :edit, :update, :destroy]

  # GET /order_final_statuses
  # GET /order_final_statuses.json
  def index
    @order_final_statuses = OrderFinalStatus.all
  end

  # GET /order_final_statuses/1
  # GET /order_final_statuses/1.json
  def show
  end

  # GET /order_final_statuses/new
  def new
    @order_final_status = OrderFinalStatus.new
  end

  # GET /order_final_statuses/1/edit
  def edit
  end

  # POST /order_final_statuses
  # POST /order_final_statuses.json
  def create
    @order_final_status = OrderFinalStatus.new(order_final_status_params)

    respond_to do |format|
      if @order_final_status.save
        format.html { redirect_to @order_final_status, notice: 'Order final status was successfully created.' }
        format.json { render :show, status: :created, location: @order_final_status }
      else
        format.html { render :new }
        format.json { render json: @order_final_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /order_final_statuses/1
  # PATCH/PUT /order_final_statuses/1.json
  def update
    respond_to do |format|
      if @order_final_status.update(order_final_status_params)
        format.html { redirect_to @order_final_status, notice: 'Order final status was successfully updated.' }
        format.json { render :show, status: :ok, location: @order_final_status }
      else
        format.html { render :edit }
        format.json { render json: @order_final_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /order_final_statuses/1
  # DELETE /order_final_statuses/1.json
  def destroy
    @order_final_status.destroy
    respond_to do |format|
      format.html { redirect_to order_final_statuses_url, notice: 'Order final status was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order_final_status
      @order_final_status = OrderFinalStatus.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_final_status_params
      params.require(:order_final_status).permit(:name, :sort_order, :description)
    end
end
