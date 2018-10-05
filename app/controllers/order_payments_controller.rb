class OrderPaymentsController < ApplicationController
  before_action { protect_controllers(5) } 
  before_action :set_order_payment, only: [:show, :edit, :update, :destroy]
  before_action :set_employee
  respond_to :html

  def index
    mode_ids = [10100, 10101, 10102]
    @btn1 = "btn btn-default"
    @btn2 = "btn btn-default"
    @btn3 = "btn btn-default"
    
    @order_payment_modes = Orderpaymentmode.where(id: mode_ids)
    @from_date = (Date.current - 3.days).beginning_of_day - 330.minutes #30.days
    @to_date = Date.current.end_of_day - 330.minutes
    if params[:from_date].present?
      @from_date = (Date.strptime(params[:from_date], "%Y-%m-%d")).beginning_of_day - 330.minutes
      @to_date = (Date.strptime(params[:from_date], "%Y-%m-%d")).end_of_day - 330.minutes
      if params.has_key?(:to_date)
        @to_date =  Date.strptime(params[:to_date], "%Y-%m-%d")
      end
      @to_date = @to_date.end_of_day - 330.minutes
    end
    @order_payments = OrderPayment.where('created_at >= ? and created_at <= ?', @from_date, @to_date)
    if params[:orderpaymentmode_id].present?
      @order_payment_mode_id = params[:orderpaymentmode_id]
      # if @order_payment_mode_id.to_i > 0
        @order_payments = @order_payments.where(:orderpaymentmode_id => @order_payment_mode_id)
      # end
    end
    @from_date = (@from_date + 330.minutes).strftime("%Y-%m-%d")
    @to_date = (@to_date + 330.minutes).strftime("%Y-%m-%d")
    
    if params.has_key?(:filter)
      filter = params[:filter]
      
      case filter # a_variable is the variable we want to compare
        when "paid"   #compare to 1
          @btn2 = "btn btn-success"
          @order_payments = @order_payments.where.not(:paid_date => nil).paginate(:page => params[:page])
        when "unpaid"    #compare to 2
          @btn3 = "btn btn-success"
          @order_payments = @order_payments.where(:paid_date => nil).paginate(:page => params[:page])
        when "all"    #compare to 2
          @btn1 = "btn btn-success"
          @order_payments = @order_payments.paginate(:page => params[:page])
      end
    else
      @order_payments = @order_payments.paginate(:page => params[:page])
    end
    
    #@order_payments = OrderPayment.all
  end

  def show
    
    @return_url = request.original_url
    @order_id = @order_payment.order_master_id
    if @order_id.blank?
      redirect_to order_payments_path, flash[:success] = "No details found for order ref #{@order_id} to show results " and return 
    end
    
       
    @order_master = OrderMaster.find(@order_id)
    if @order_master.blank?
      redirect_to order_payments_path, flash[:success] = "No details found for order ref #{@order_id} to show results " and return 
    end
    
    @order_lines_regular = OrderLine.where(orderid: @order_id)
    .joins(:product_variant)
    .where('PRODUCT_VARIANTS.product_sell_type_id = ?', 10000)

    @order_lines_basic = OrderLine.where(orderid: @order_id)
    .joins(:product_variant)
    .where('product_variants.product_sell_type_id = ?', 10040)

    @order_lines_common = OrderLine.where(orderid: @order_id)
    .joins(:product_variant)
    .where('product_variants.product_sell_type_id = ?', 10001)

    @order_lines_free = OrderLine.where(orderid: @order_id)
    .joins(:product_variant)
    .where('product_variants.product_sell_type_id = ?', 10060)
    

  end

  def new
    @order_payment = OrderPayment.new
    respond_with(@order_payment)
  end

  def edit
    @return_url = request.original_url
    @order_id = @order_payment.order_master_id
    if @order_id.blank?
      redirect_to order_payments_path, flash[:success] = "No details found for order ref #{@order_id} to show results " and return 
    end
    
       
    @order_master = OrderMaster.find(@order_id)
    if @order_master.blank?
      redirect_to order_payments_path, flash[:success] = "No details found for order ref #{@order_id} to show results " and return 
    end
    
    @order_lines_regular = OrderLine.where(orderid: @order_id)
    .joins(:product_variant)
    .where('PRODUCT_VARIANTS.product_sell_type_id = ?', 10000)

    @order_lines_basic = OrderLine.where(orderid: @order_id)
    .joins(:product_variant)
    .where('product_variants.product_sell_type_id = ?', 10040)

    @order_lines_common = OrderLine.where(orderid: @order_id)
    .joins(:product_variant)
    .where('product_variants.product_sell_type_id = ?', 10001)

    @order_lines_free = OrderLine.where(orderid: @order_id)
    .joins(:product_variant)
    .where('product_variants.product_sell_type_id = ?', 10060)
    
  end
  
  def update
    @order_payment.update(order_payment_params)
    message = @order_payment.process_order_payment
    flash[:error] = message
    flash[:notice] = message
    respond_with(@order_payment)
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
     
    @pending_orders = PendingOrder.where("TRUNC(order_date) >= ? and TRUNC(order_date) <= ?", @from_date,@to_date).order(created_at: :DESC)

    
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
  

  def create
    @order_payment = OrderPayment.new(order_payment_params)
    @order_payment.save
    respond_with(@order_payment)
  end



  def destroy
    @order_payment.destroy
    respond_with(@order_payment)
  end

  private
    def set_order_payment
      @orderpaymentmodes = Orderpaymentmode.all
      @order_payment = OrderPayment.find(params[:id])
    end

    def order_payment_params
      params.require(:order_payment).permit(:order_master_id, :ref_no, :orderpaymentmode_id, 
      :paid_date, :paid_amount, :name, :description, :card_no, :employee_id)
    end
    
    def set_employee
      @employee = Employee.where(employeecode: current_user.employee_code).first
    end
end
