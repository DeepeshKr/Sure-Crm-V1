class MessageOnOrdersController < ApplicationController
  before_action :set_message_on_order, only: [:show, :edit, :update, :destroy]

  # GET /message_on_orders
  # GET /message_on_orders.json
  def index
   @message_details = "Recent Message On Orders"
   @btn1 = "btn btn-default"
   @btn2 = "btn btn-default"
   @btn3 = "btn btn-default"
   todaydate = (Date.current + 330.minutes)# Date.today
   #30.days
   from_date = todaydate
   @to_date = todaydate.strftime("%Y-%m-%d")   #30.days
   from_date = todaydate - 2.days
   @from_date = (from_date).strftime("%Y-%m-%d")  
   if params.has_key?(:from_date)
       from_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
       @from_date = from_date.beginning_of_day - 330.minutes
       @to_date = from_date.end_of_day - 330.minutes
   end
   if params.has_key?(:to_date)
      to_date =  Date.strptime(params[:to_date], "%Y-%m-%d")
      @to_date = to_date.end_of_day - 330.minutes
   end
   
    if params.has_key?(:status)
     status = params[:status]
     status = status.to_i
     
      @message_on_orders = MessageOnOrder.where("created_at >= ? and created_at <= ?", @from_date,@to_date).where(message_status_id: status, message_type_id: 10000).order("updated_at DESC").paginate(:page => params[:page], :per_page => 100)
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
      #.limit(10000)
    @message_on_orders = MessageOnOrder.where("created_at >= ? and created_at <= ?", @from_date,@to_date).where(message_type_id: 10000).order("updated_at DESC").paginate(:page => params[:page], :per_page => 100)
     @message_details = "Order Messages"

     @from_date = (from_date + 330.minutes).strftime("%Y-%m-%d") if from_date.present?
     @to_date = (from_date + 330.minutes).strftime("%Y-%m-%d") if from_date.present?
   
    end
    
        @page_heading = "Messages between #{@from_date} and #{@to_date}"
  end
  
  # GET /message_on_orders
  # GET /message_on_orders.json
  def payumoney
   message_details = "Pay U Money Orders"
   @btn1 = "btn btn-default"
   @btn2 = "btn btn-default"
   @btn3 = "btn btn-default"
   todaydate = (Date.current + 330.minutes)# Date.today
   #30.days
   @to_date = todaydate.strftime("%Y-%m-%d")   #30.days
   @from_date = (todaydate - 2.days).strftime("%Y-%m-%d")  
   if params.has_key?(:from_date)
       from_date =  Date.strptime(params[:from_date], "%Y-%m-%d")
       @from_date = from_date #.to_date - 7.days #30.days
       @to_date = from_date.to_date
   end
   if params.has_key?(:to_date)
      @to_date =  Date.strptime(params[:to_date], "%Y-%m-%d")
   end
   
    if params.has_key?(:status)
     status = params[:status]
     status = status.to_i
     
     
     
      @message_on_orders = MessageOnOrder.where("TRUNC(created_at) >= ? and TRUNC(created_at) <= ?", @from_date,@to_date).where(message_status_id: status, message_type_id: 10020).order("updated_at DESC").paginate(:page => params[:page], :per_page => 100)
      case status # a_variable is the variable we want to compare
        when 10000    #compare to 1
          @btn1 = "btn btn-info"
          @message_details = "#{message_details}: In Queue"
        when 10002    #compare to 2
          @btn2 = "btn btn-danger"
           @message_details = "#{message_details}: Not delivered"
        when 10004
         @btn3 = "btn btn-success"
          @message_details = "#{message_details}: Delivered"
        else
          @message_details = "#{message_details}: Wrong Selection made"
      end

    else
      #.limit(10000)
    @message_on_orders = MessageOnOrder.where(message_type_id: 10020).order("updated_at DESC").limit(10000).paginate(:page => params[:page], :per_page => 100)
    end
    @message_details = "Pay U Money Messages"
    @page_heading = "Pay U Money Messages between #{@from_date} and #{@to_date}"
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

  def send_demo_message
    mobile = params[:mobile]
    order_no = params[:order_no]
    order_val = params[:order_val]
    username = "Telebrands"
    password = "Telebrands"
    cdmaheader = "TBRAND"
    senderid = "TBRAND"

    require "net/http"
    require "uri"
    require 'open-uri'
#Thanks for order no 3161275 for Rs 5767, products will reach you in 7-10 days. Please pay cash on delivery any queries Call 9223100730 HBN / TELEBRANDS
          message = "Thanks for order no #{order_no} for Rs #{order_val}, products will reach you in 7-10 days. Please pay cash on delivery any queries Call 9223100730 HBN / TELEBRANDS"

          message = message[0..159]
          # "http://whitelist.smsapi.org/SendSMS.aspx?UserName=#{username}&password=#{password}&SenderID=#{senderid}&CDMAHeader=#{cdmaheader}&MobileNo=#{mobile}&Message=#{message}"
# http://whitelist.smsapi.org/SendSMS.aspx?UserName=Telebrands&password=Telebrands&SenderID=TBRAND&CDMAHeader=TBRAND&MobileNo=xxxxxxxxxx&Message=Thanks for order no 3160089 for Rs 2618, products will reach you in 7-10 days. Please pay cash on delivery any queries Call 9223100730 HBN / TELEBRANDS
          weburl = "http://whitelist.smsapi.org/SendSMS.aspx?UserName=#{username}&password=#{password}&SenderID=#{senderid}&CDMAHeader=#{cdmaheader}&MobileNo=#{mobile}&Message=#{message}"

          response = url_response(weburl)
    flash[:error] = "Sent to website #{weburl} Response from website #{response.body}"
    redirect_to message_on_orders_path
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

    def url_response(weburl)
      weburl = URI::encode(weburl)
      uri = URI.parse(weburl)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
      return response = http.request(request)

    end

end
