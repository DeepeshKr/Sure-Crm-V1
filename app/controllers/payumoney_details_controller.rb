class PayumoneyDetailsController < ApplicationController
  before_action { protect_controllers(8) }
 #before_action :set_payumoney_detail, only: [:search, :index]

 respond_to :html

  def index
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
    
    @page_heading = "Pay u money detail for id #{params[:id]}"
    @payumoney_detail = PayumoneyDetail.find(params[:id])

  end
private
  # def set_payumoney_detail
 #    @payumoney_detail = PayumoneyDetail.find(params[:id])
 #  end
  def payumoney_detail_params
    params.require(:payumoney_detail).permit(:paymentId, :merchantTransactionId, :amount, :customerMobileNumber, :status, :orderid, :final_order_id, :full_response)

  end
end
