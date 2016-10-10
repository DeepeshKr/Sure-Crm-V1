class CustomerOrderListsController < ApplicationController
  before_action :set_customer_order_list, only: [:show, :edit, :update, :destroy, :inoracle]

  respond_to :html

  def index
    if params[:ordernum].present?
        @ordernum = params[:ordernum]
           @customer_order_lists = CustomerOrderList.where("ordernum = ? or id = ?", @ordernum, @ordernum).order("id DESC").limit(200)
   else
     @customer_order_lists = CustomerOrderList.where("ordernum is not null").order("id DESC").limit(10)
    #    @customer_order_lists = CustomerOrderList.order("id DESC").limit(100)
    end

    respond_with(@customer_order_lists)
  end

  def show
    order_masters = OrderMaster.where(external_order_no: @customer_order_list.ordernum)
    if order_masters.present?
      #if @order_master.customer_address_id.present?
        @customer_address = CustomerAddress.find(order_masters.first.customer_address_id)
        @order_master = order_masters.first
        @order_lines = OrderLine.where(orderid: @order_master.id).order("id")
      #end
    end
    @return_url = request.original_url
    @regenerate_ppo = "Regenerate to CustDetails: #{@customer_order_list.custdetails} #{@customer_order_list.vpp} #{@customer_order_list.dealtran} "

  #  respond_with(@customer_order_list)
  end

  def new
    @customer_order_list = CustomerOrderList.new
    respond_with(@customer_order_list)
  end

  def edit
  end

  def inoracle
    @customer_order_list = CustomerOrderList.find(params[:id])
    update_page_trail("Recreate CustDetails", @customer_order_list.order_id, "ref id #{params[:id]}")
    notice = @customer_order_list.regenerate_customer_order_list
    if params.has_key?(:return_url)
      @return_url = params[:return_url]
      redirect_to @return_url, notice: "#{notice}"
   else
      redirect_to customer_order_lists_path, notice: "The process of recreating #{nos} is complete."
    end
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
    def update_page_trail(page_name, order_id, params = nil)
      url = "#{request.original_url} #{params}" 
      @empcode = current_user.employee_code
      employee_id = Employee.where(employeecode: @empcode).first.id
      #.permit(:name, :order_id, :page_id, :url, :employee_id, :duration_secs)
      PageTrail.create(name: page_name, order_id: order_id, url: url, employee_id: employee_id)

    end

end
