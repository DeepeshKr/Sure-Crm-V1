class MessageOnOrdersController < ApplicationController
  before_action :set_message_on_order, only: [:show, :edit, :update, :destroy]

  # GET /message_on_orders
  # GET /message_on_orders.json
  def index
   @message_details = "Recent Message On Orders"
   @btn1 = "btn btn-default" 
   @btn2 = "btn btn-default"
   @btn3 = "btn btn-default"
    if params.has_key?(:status)
     status = params[:status]
     status = status.to_i
     
      @message_on_orders = MessageOnOrder.where(message_status_id: status)
      .order("updated_at DESC").limit(10000)
      .paginate(:page => params[:page], :per_page => 100) 
      case status # a_variable is the variable we want to compare
        when 10000    #compare to 1
          @btn1 = "btn btn-info"
          @message_details = "Recent Message for Status: In Queue"
        when 10002    #compare to 2
          @btn2 = "btn btn-danger"
           @message_details = "Recent Message for Status: Not delivered"
        when 10004
         @btn3 = "btn btn-success"
          @message_details = "Recent Message for Status: Delivered"
        else
          @message_details = "Wrong Selection made"
      end
 
    else
    @message_on_orders = MessageOnOrder.all.order("updated_at DESC").limit(10000).paginate(:page => params[:page], :per_page => 100) 
    end
  end

  # GET /message_on_orders/1
  # GET /message_on_orders/1.json
  def show
  end

  # GET /message_on_orders/new
  def new
    @message_on_order = MessageOnOrder.new
  end

  # GET /message_on_orders/1/edit
  def edit
  end

  # POST /message_on_orders
  # POST /message_on_orders.json
  def create
    @message_on_order = MessageOnOrder.new(message_on_order_params)

    respond_to do |format|
      if @message_on_order.save
        format.html { redirect_to @message_on_order, notice: 'Message on order was successfully created.' }
        format.json { render :show, status: :created, location: @message_on_order }
      else
        format.html { render :new }
        format.json { render json: @message_on_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /message_on_orders/1
  # PATCH/PUT /message_on_orders/1.json
  def update
    respond_to do |format|
      if @message_on_order.update(message_on_order_params)
        format.html { redirect_to @message_on_order, notice: 'Message on order was successfully updated.' }
        format.json { render :show, status: :ok, location: @message_on_order }
      else
        format.html { render :edit }
        format.json { render json: @message_on_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /message_on_orders/1
  # DELETE /message_on_orders/1.json
  def destroy
    @message_on_order.destroy
    respond_to do |format|
      format.html { redirect_to message_on_orders_url, notice: 'Message on order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    
    # Use callbacks to share common setup or constraints between actions.
    def set_message_on_order
      @message_on_order = MessageOnOrder.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_on_order_params
      params.require(:message_on_order).permit(:customer_id, :message_type_id, :message_status_id, :message, :response, :mobile_no, :alt_mobile_no)
    end
end
