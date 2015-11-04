class DistributorMissedOrdersController < ApplicationController
  before_action :set_distributor_missed_order, only: [:show, :edit, :update, :destroy]

  # GET /distributor_missed_orders
  # GET /distributor_missed_orders.json
  def index
    @btn1 = "btn btn-default" 
    @btn2 = "btn btn-default"
    if params.has_key?(:corporate_id)
      @corporate = Corporate.find(params[:corporate_id])
      @distributor_missed_orders = DistributorMissedOrder.where(corporate_id: params[:corporate_id]).paginate(:page => params[:page], :per_page => 100) 
      if params.has_key?(:type_id)
        @distributor_missed_orders =  @distributor_missed_orders.where(type_id: params[:type_id]).paginate(:page => params[:page], :per_page => 100) 
        status = params[:type_id].to_i
        case status # a_variable is the variable we want to compare
          when 10000    #compare to 1
            @btn1 = "btn btn-success"
            @message_details = "Showing MIS Low Cases"
          when 10001    #compare to 2
            @btn2 = "btn btn-success"
            @message_details = "Showing Product Stock Low cases"
          else
            @message_details = "Wrong Selection made"
        end
      end
    else
      @distributor_missed_orders = DistributorMissedOrder.order("summary_date DESC").limit(100).paginate(:page => params[:page], :per_page => 100) 
    end
   
 
  end
 

  # GET /distributor_missed_orders/1
  # GET /distributor_missed_orders/1.json
  def show
  end

  # GET /distributor_missed_orders/new
  def new
    @distributor_missed_order = DistributorMissedOrder.new
  end

  # GET /distributor_missed_orders/1/edit
  def edit
  end

  # POST /distributor_missed_orders
  # POST /distributor_missed_orders.json
  def create
    @distributor_missed_order = DistributorMissedOrder.new(distributor_missed_order_params)

    respond_to do |format|
      if @distributor_missed_order.save
        format.html { redirect_to @distributor_missed_order, notice: 'Distributor missed order was successfully created.' }
        format.json { render :show, status: :created, location: @distributor_missed_order }
      else
        format.html { render :new }
        format.json { render json: @distributor_missed_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /distributor_missed_orders/1
  # PATCH/PUT /distributor_missed_orders/1.json
  def update
    respond_to do |format|
      if @distributor_missed_order.update(distributor_missed_order_params)
        format.html { redirect_to @distributor_missed_order, notice: 'Distributor missed order was successfully updated.' }
        format.json { render :show, status: :ok, location: @distributor_missed_order }
      else
        format.html { render :edit }
        format.json { render json: @distributor_missed_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /distributor_missed_orders/1
  # DELETE /distributor_missed_orders/1.json
  def destroy
    @distributor_missed_order.destroy
    respond_to do |format|
      format.html { redirect_to distributor_missed_orders_url, notice: 'Distributor missed order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_distributor_missed_order
      @distributor_missed_order = DistributorMissedOrder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def distributor_missed_order_params
      params.require(:distributor_missed_order).permit(:corporate_id, :missed_type_id, :order_value, :order_no, :order_id, :description)
    end
end
