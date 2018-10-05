class PendingOrdersController < ApplicationController
  before_action :set_pending_order, only: [:show, :edit, :update, :destroy]
  before_action :set_host
  # GET /pending_orders
  # GET /pending_orders.json
  def index
    @btn1 = "btn btn-default"
    @btn2 = "btn btn-default"
    @btn3 = "btn btn-default"
    
    
    @from_date = Date.current - 30.days #30.days
    @to_date = Date.current
    if params[:from_date].present?
      #@summary ||= []
      @or_for_date = params[:from_date]
      for_date =  Date.strptime(params[:from_date], "%Y-%m-%d")

      @from_date = for_date.beginning_of_day - 330.minutes
      @to_date = for_date.end_of_day - 330.minutes
      #@to_date = @from_date + 1.day

      if params.has_key?(:to_date)
        @to_date =  Date.strptime(params[:to_date], "%Y-%m-%d")
      end

      @to_date = @to_date.end_of_day - 330.minutes
    end
    @pending_orders = PendingOrder.where("TRUNC(order_date) >= ? and TRUNC(order_date) <= ?", @from_date,@to_date).order(updated_at: :DESC).paginate(:page => params[:page])

     
    if params.has_key?(:payumoney_status_id)
      status = params[:payumoney_status_id].to_i
      
      case status # a_variable is the variable we want to compare
        when 0    #compare to 1
          @btn1 = "btn btn-success"
          @pending_orders = @pending_orders.where(:pay_u_status_id => nil)
        when 10003    #compare to 2
          @btn2 = "btn btn-success"
           @pending_orders = @pending_orders.where(pay_u_status_id: status)
        else
          @pending_orders = @pending_orders.where(pay_u_status_id: status)
      end
    end
    
    @mobile_no = nil
    @order_ref_no = nil
    
    if params.has_key?(:mobile_no)
      @mobile_no = params[:mobile_no].strip
      @pending_orders = PendingOrder(customerMobileNumber: @mobile_no).order("updated_at DESC").paginate(:page => params[:page], :per_page => 20)
    end
    
    if params.has_key?(:order_ref_no)
      @order_ref_no = params[:order_ref_no].strip()
      @pending_orders = PendingOrder.where(orderid: @order_ref_no).order("updated_at DESC").paginate(:page => params[:page], :per_page => 20)
    end
    
    if params.has_key?(:manifest)
      @manifest = params[:manifest].strip()
      @pending_orders = PendingOrder.where(:manifest => @manifest).order("updated_at DESC").paginate(:page => params[:page], :per_page => 20)
    end
    file_name = "Pending_order_list"
    respond_to do |format|
      format.html
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"#{file_name}\""
        headers['Content-Type'] ||= 'text/csv'
      end
    end
   
  end
  
  def multi_edit
    @from_date = Date.current - 60.days #30.days
    @to_date = Date.current
    if params[:from_date].present?
      @from_date = Date.strptime(params[:from_date], "%Y-%m-%d").beginning_of_day - 330.minutes
      @to_date = Date.strptime(params[:from_date], "%Y-%m-%d").end_of_day - 330.minutes

      if params.has_key?(:to_date)
        @to_date =  Date.strptime(params[:to_date], "%Y-%m-%d")
      end
      
      @to_date = @to_date.end_of_day - 330.minutes
    end
     
    @pending_orders = PendingOrder.where("TRUNC(order_date) >= ? and TRUNC(order_date) <= ?", @from_date,@to_date).order(created_at: :DESC).paginate(:page => params[:page])

     
    
    respond_to do |format|
      format.html
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"#{file_name}\""
        headers['Content-Type'] ||= 'text/csv'
      end
    end
  end
  
  def edit_multiple
    @pay_u_status = PayumoneyStatus.all
    @pending_orders = PendingOrder.find(params[:pending_orders])
  end
  
  def update_multiple
     @pay_u_status = PayumoneyStatus.all
     @pending_orders = PendingOrder.find(params[:pending_orders])
      @pending_orders.each do |pending_order|
        pending_order.update_attributes!(params[:pending_order].reject { |k,v| v.blank? })
      end
      flash[:notice] = "Updated Pending Ordes!"
      redirect_to pending_orders_path
  end
  
  # GET /pending_orders/1
  # GET /pending_orders/1.json
  def show
  end

  # GET /pending_orders/new
  def new
    @pending_order = PendingOrder.new
  end

  # GET /pending_orders/1/edit
  def edit
  end
  
  def import
    message = PendingOrder.import(params[:file])
    redirect_to pending_orders_url, notice: message
  end
  
  # POST /generate_orders
  def generate_orders
    @from_date = Date.current - 3.days #30.days
    @to_date = Date.current
    if params[:from_date].present?
      #@summary ||= []
      @or_for_date = params[:from_date]
      for_date =  Date.strptime(params[:from_date], "%Y-%m-%d")

      @from_date = for_date.beginning_of_day - 330.minutes
      @to_date = for_date.end_of_day - 330.minutes
      #@to_date = @from_date + 1.day

      if params.has_key?(:to_date)
        @to_date =  Date.strptime(params[:to_date], "%Y-%m-%d")
      end

      @to_date = @to_date.end_of_day - 330.minutes
    end
    order_masters = OrderMaster.where('orderdate >= ? and orderdate <= ?', @from_date, @to_date)
    .where(order_status_master_id: 10005, orderpaymentmode_id: 10001)
    
    order_masters.each do |order_master|
      PendingOrder.create_list order_master.id
    end
     redirect_to pending_orders_url, notice: "Generated the list for pending orders between #{@from_date} and #{@to_date}"
    
  end
  
  def generate_pay_u_sms
    @order_id = params[:order_id]
    message = PendingOrder.send_pay_u_sms_invoice @order_id
    redirect_to pending_orders_url, notice: "#{message}"
  end
  
  def generate_order_for_order_id
    @order_id = params[:order_id]
    redirect_to pending_orders_url, notice: "Generated the list for pending orders for order id #{@order_id}"
  end
  
  def generate_order_for_order_no
    @order_no = params[:order_no]
    redirect_to pending_orders_url, notice: "Generated the list for pending orders for order no #{@order_no}"
  end

  # POST /pending_orders
  # POST /pending_orders.json
  def create
    @pending_order = PendingOrder.new(pending_order_params)

    respond_to do |format|
      if @pending_order.save
        format.html { redirect_to @pending_order, notice: 'Pending order was successfully created.' }
        format.json { render :show, status: :created, location: @pending_order }
      else
        format.html { render :new }
        format.json { render json: @pending_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pending_orders/1
  # PATCH/PUT /pending_orders/1.json
  def update
    respond_to do |format|
      if @pending_order.update(pending_order_params)
        format.html { redirect_to @pending_order, notice: 'Pending order was successfully updated.' }
        format.json { render :show, status: :ok, location: @pending_order }
      else
        format.html { render :edit }
        format.json { render json: @pending_order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pending_orders/1
  # DELETE /pending_orders/1.json
  def destroy
    @pending_order.destroy
    respond_to do |format|
      format.html { redirect_to pending_orders_url, notice: 'Pending order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pending_order
      @pending_order = PendingOrder.find(params[:id])
    end
    
    def set_host
      # for returning to the same page
     @host = request.host
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def pending_order_params
      params.require(:pending_order).permit(:order_ref_id, :order_no, :order_dispatch_status_id, :cod_amount, :pay_u_amount, :courier_list_id, :pay_u_status_id, :dispatch_call_status_id, :airway_bill, :pod, :order_date)
    end
end
