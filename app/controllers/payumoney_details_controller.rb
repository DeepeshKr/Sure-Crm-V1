class PayumoneyDetailsController < ApplicationController
  before_action { protect_controllers(8) }
 #before_action :set_payumoney_detail, only: [:search, :index]

 respond_to :html

  def index
    @btn1 = "btn btn-default"
    @btn2 = "btn btn-default"
    @btn3 = "btn btn-default"
    
    todaydate = (Date.current + 330.minutes)# Date.today
    #30.days
    @from_date = todaydate.beginning_of_day - 330.minutes
    @to_date = todaydate.end_of_day - 330.minutes

    if params.has_key?(:from_date)
      from_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
      @from_date = from_date.beginning_of_day - 330.minutes
      @to_date = from_date.end_of_day - 330.minutes
    end

    if params.has_key?(:to_date)
      to_date =  Date.strptime(params[:to_date], "%Y-%m-%d")
      @to_date = (to_date.end_of_day - 330.minutes)
    end
    @payumoney_details = PayumoneyDetail.where("created_at >= ? and created_at <= ?", @from_date,@to_date).order("updated_at DESC").paginate(:page => params[:page], :per_page => 20)
    
    
    if params.has_key?(:payumoney_status_id)
      status = params[:payumoney_status_id].to_i
      @message_details = "Showing all #{PayumoneyStatus.find(status).name} orders"
      case status # a_variable is the variable we want to compare
        when 10000    #compare to 1
          @btn1 = "btn btn-success"
          @payumoney_details = @payumoney_details.where(payumoney_status_id: status)
        when 10003    #compare to 2
          @btn2 = "btn btn-success"
           @payumoney_details = @payumoney_details.where(payumoney_status_id: status)
        else
          @payumoney_details = @payumoney_details.where(payumoney_status_id: status)
      end
    end
    
    @mobile_no = nil
    @order_ref_no = nil
    
    if params.has_key?(:mobile_no)
      @mobile_no = params[:mobile_no].strip
      @payumoney_details = PayumoneyDetail.where(customerMobileNumber: @mobile_no).order("updated_at DESC").paginate(:page => params[:page], :per_page => 20)
    end
    
    if params.has_key?(:order_ref_no)
      @order_ref_no = params[:order_ref_no].strip()
        @payumoney_details = PayumoneyDetail.where(orderid: @order_ref_no).order("updated_at DESC").paginate(:page => params[:page], :per_page => 20)
    end
    
    if params.has_key?(:pay_u_ref)
      @pay_u_ref = params[:pay_u_ref].strip()
        @payumoney_details = PayumoneyDetail.where(:merchantTransactionId => @pay_u_ref).order("updated_at DESC").paginate(:page => params[:page], :per_page => 20)
    end
    
    @from_date = (@from_date + 330.minutes).strftime("%Y-%m-%d")
    @to_date = (@to_date + 330.minutes).strftime("%Y-%m-%d")

     @page_heading = "Pay u Money details between #{@from_date} and #{@to_date}"
  end

  def open_orders
    @current_time = Time.zone.now
    @order_ref_no = nil
    @merchant_transaction_id =  nil
    @payumoney_details = PayumoneyDetail.joins(:order_master).where("order_masters.order_source_id = 10060 and order_masters.order_status_master_id = 10001 and order_masters.orderpaymentmode_id = 10080").order("payumoney_details.last_check_at DESC")
    # if params.has_key?(:order_ref_no)
    #   @order_ref_no = params[:order_ref_no]
    #     @payumoney_details = @payumoney_details.where(orderid: @order_ref_no)
    # end
    # if params.has_key?(:merchant_transaction_id)
    #   @merchant_transaction_id = params[:merchant_transaction_id]
    #   @payumoney_details = @payumoney_details.where(merchantTransactionId: @merchant_transaction_id)
    # end

    #@payumoney_details = @payumoney_details.paginate(:page => params[:page], :per_page => 20)
    @total_open_orders = @payumoney_details.count || 0 if @payumoney_details.present?
    @page_heading = "Pay u Money Open Orders #{@total_open_orders}"
  end
  
  def search

  end

  def details
    @allow_to_close = false
   
    @payumoney_detail = PayumoneyDetail.find(params[:id])
    @pay_u_id = @payumoney_detail.id
    @return_url = request.original_url
    order_review @payumoney_detail.orderid
    
    # if (@payumoney_detail.payumoney_status_id != 10006 && @payumoney_detail.payumoney_status_id != 10007)
 #
 #    end
    
    # if @order_master.order_status_master_id < 10003
   #     @allow_to_close = true
   #  end 
     @page_heading = "Pay u money detail for order id #{@payumoney_detail.orderid} pay u ref id #{params[:id]}"
  end
  
  def process_order
     this_time = Time.zone.now + 330.minutes
   if !params.has_key?(:pay_u_id)
      if params.has_key?(:return_url)
        @return_url = params[:return_url]
        redirect_to @return_url, notice: "No details found to process order, try again." and return
     else
        redirect_to payumoney_details_path, notice: "No details found to process order, try again." and return
      end

    end
    
    @pay_u_id = params[:pay_u_id]
    user_details = params[:user_details]
    
    @payumoney = PayumoneyDetail.find(@pay_u_id)
    transaction_history = @payumoney.transaction_history
    @payumoney.update(transaction_history: "#{transaction_history} \r\nEmployee manually processed the order with pay u response code #{user_details} executed at #{this_time}")
    
    order_master = OrderMaster.find @payumoney.orderid
    
    redirect_to payumoney_details_path, notice: "No details found to process order, try again." and return if order_master.blank?
    
    @payumoney.update(payumoney_status_id: 10006)
    order_master.update(orderpaymentmode_id: 10080)
    response = order_master.process_order @payumoney.orderid
    flash[:error] = "#{response}"
    
    if params.has_key?(:return_url)
      @return_url = params[:return_url]
      redirect_to @return_url, notice: "The order has been processed for order ref no #{@payumoney.orderid}." 
   else
      redirect_to payumoney_details_path, notice: "The order has been processed for order ref no #{@payumoney.orderid}."
    end
    
  end
  
  def regenerate_sms_for_order
     this_time = Time.zone.now + 330.minutes
    
    if !params.has_key?(:pay_u_id)
      if params.has_key?(:return_url)
        @return_url = params[:return_url]
        redirect_to @return_url, notice: "TNo details found to process order, try again." and return
     else
        redirect_to payumoney_details_path, notice: "No details found to process order, try again." and return
      end

    end
    @pay_u_id = params[:pay_u_id]
    user_details = params[:user_details]
      
     @payumoney = PayumoneyDetail.find(@pay_u_id)
    user_details = params[:user_details]
    
    transaction_history = @payumoney.transaction_history
    @payumoney.update(transaction_history: "#{transaction_history} \r\nEmployee manually regenerated the order sms with user feedback #{user_details} executed at #{this_time}")
    
    order_master = OrderMaster.find(@payumoney.orderid)
    
    redirect_to payumoney_details_path, notice: "No details found to process order, try again." and return if order_master.blank?
    
    response = order_master.regenerate_pay_u_sms_invoice @payumoney.orderid 
    flash[:error] = "#{response}"
    
    if params.has_key?(:return_url)
      @return_url = params[:return_url]
      redirect_to @return_url, notice: "The pay u sms is regenerated for order ref no #{@payumoney.orderid}."
   else
      redirect_to payumoney_details_path, notice: "The pay u sms is regenerated for order ref no #{@payumoney.orderid}."
    end
    
  end
  
private
  # def set_payumoney_detail
 #    @payumoney_detail = PayumoneyDetail.find(params[:id])
 #  end
  def payumoney_detail_params
    params.require(:payumoney_detail).permit(:paymentId, :merchantTransactionId, :amount, :customerMobileNumber, :status, :orderid, :final_order_id, :full_response)

  end
 
  def order_review order_id
    @order_id = order_id
    @order_master = OrderMaster.find(@order_id)
    
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
  
    #sms
    @message_on_orders = MessageOnOrder.where(message_type_id: 10000, order_id: @order_id).order("id DESC")
   
    #payumoney
    @message_on_pay_u_orders = MessageOnOrder.where(message_type_id: 10020, order_id: @order_id)
    @payumoney_details = PayumoneyDetail.where(orderid: @order_id)
    #ppo
    
  end
end
