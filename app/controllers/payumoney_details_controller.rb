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
     
     @from_date = (@from_date + 330.minutes).strftime("%Y-%m-%d")
     @to_date = (@to_date + 330.minutes).strftime("%Y-%m-%d")
     
     @page_heading = "Pay u Money details between #{@from_date} and #{@to_date}"
  end

  def search
    
  end
private
  # def set_payumoney_detail
 #    @payumoney_detail = PayumoneyDetail.find(params[:id])
 #  end
  def payumoney_detail_params
    params.require(:payumoney_detail).permit(:paymentId, :merchantTransactionId, :amount, :customerMobileNumber, :status, :orderid, :final_order_id, :full_response)
   
  end
end
