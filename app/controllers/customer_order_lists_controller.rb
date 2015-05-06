class CustomerOrderListsController < ApplicationController
  before_action :set_customer_order_list, only: [:show, :edit, :update, :destroy, :inoracle]

  respond_to :html

  def index
    if params[:complete].present?
        if params[:complete] = 'yes'
           @customer_order_lists = CustomerOrderList.where("ordernum is not null").order("id DESC").limit(200)
        end
    elsif params[:ordernum].present?
        
           @customer_order_lists = CustomerOrderList.where("ordernum = ?", params[:ordernum]).order("id DESC").limit(200)
       
   else
     @customer_order_lists = CustomerOrderList.where(ordernum: nil).order("id DESC").limit(200)
    #    @customer_order_lists = CustomerOrderList.order("id DESC").limit(100)
    end
   
    respond_with(@customer_order_lists)
  end

  def show
    respond_with(@customer_order_list)
  end

  def new
    @customer_order_list = CustomerOrderList.new
    respond_with(@customer_order_list)
  end

  def edit
  end

  def inoracle
    update_customer_order_list
    respond_with(@customer_order_list)
  end

  def create
    @customer_order_list = CustomerOrderList.new(customer_order_list_params)
    @customer_order_list.save
    respond_with(@customer_order_list)
  end

  def update
    @customer_order_list.update(customer_order_list_params)
    respond_with(@customer_order_list)
  end

  def destroy
    @customer_order_list.destroy
    respond_with(@customer_order_list)
  end

  private
    def set_customer_order_list
      @customer_order_list = CustomerOrderList.find(params[:id])
    end

    def customer_order_list_params
      params[:customer_order_list]
    end
    def update_customer_order_list

          custdetails =  CUSTDETAILS.create(ordernum: @customer_order_list.ordernum,
          orderdate:  @customer_order_list.orderdate,
          title:(@customer_order_list.title.truncate(5).upcase if @customer_order_list.title.present?),
          fname:(@customer_order_list.fname.truncate(30).upcase if @customer_order_list.fname.present?), 
          lname:(@customer_order_list.lname.truncate(30).upcase if @customer_order_list.lname.present?),
          add1: (@customer_order_list.add1.truncate(30).upcase if @customer_order_list.add1.present?), 
          add2: (@customer_order_list.add2.truncate(30).upcase if @customer_order_list.add2.present?), 
          add3: (@customer_order_list.add3.truncate(30).upcase if @customer_order_list.add3.present?),  
          landmark: (@customer_order_list.landmark.truncate(50).upcase if @customer_order_list.landmark.present?), 
          city: (@customer_order_list.city.truncate(30).upcase if @customer_order_list.city.present?),  
          mstate: (@customer_order_list.mstate.truncate(50).upcase if @customer_order_list.mstate.present?),  
          state: (@customer_order_list.state.truncate(5).upcase if @customer_order_list.state.present?),  
          pincode: @customer_order_list.pincode, 
          tel1: (@customer_order_list.tel1.truncate(20).upcase if @customer_order_list.tel1.present?),  
          tel2: (@customer_order_list.tel2.truncate(20).upcase if @customer_order_list.tel2.present?), 
          fax: (@customer_order_list.fax.truncate(20).upcase if @customer_order_list.fax.present?), 
          email: (@customer_order_list.email.truncate(20).upcase if @customer_order_list.email.present?), 
          ccnumber:  (@customer_order_list.ccnumber if @customer_order_list.ccnumber.present?), 
          expmonth:   (@customer_order_list.expmonth if @customer_order_list.expmonth.present?), 
          expyear:   (@customer_order_list.expyear if @customer_order_list.expyear.present?), 
          cardtype:  (@customer_order_list.cardtype if @customer_order_list.cardtype.present?),
          ipadd: @customer_order_list.ipadd, 
          dnis: @customer_order_list.dnis,
          channel: @customer_order_list.channel.truncate(48).upcase + ":", 
          carddisc: @customer_order_list.carddisc, 
          chqdisc: @customer_order_list.chqdisc,
          totalamt: @customer_order_list.totalamt,
          trandate: @customer_order_list.trandate,
          username: @customer_order_list.username.truncate(50).upcase,
          oper_no: @customer_order_list.oper_no,
          dt_hour: @customer_order_list.dt_hour,
          dt_min: @customer_order_list.dt_min,
          uae_status: @customer_order_list.uae_status.truncate(50).upcase,
          prod1: @customer_order_list.prod1, prod2: @customer_order_list.prod2, 
          prod3: @customer_order_list.prod3, prod4: @customer_order_list.prod4, 
          prod5: @customer_order_list.prod5, prod6: @customer_order_list.prod6, 
          prod7: @customer_order_list.prod7, prod8:@customer_order_list.prod8, 
          prod9: @customer_order_list.prod9, prod10: @customer_order_list.prod10,
          qty1: @customer_order_list.qty1, qty2: @customer_order_list.qty2, 
          qty3: @customer_order_list.qty3, qty4: @customer_order_list.qty4, 
          qty5: @customer_order_list.qty5, qty6: @customer_order_list.qty6, 
          qty7: @customer_order_list.qty7, qty8: @customer_order_list.qty8, 
          qty9: @customer_order_list.qty9, qty10: @customer_order_list.qty10)
          
        
          flash[:notice] = "Order Number is #{@customer_order_list.ordernum}" 
          
          return @customer_order_list.ordernum #customer_order_list.ordernum  
    end
end
