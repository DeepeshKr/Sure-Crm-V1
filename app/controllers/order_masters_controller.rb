class OrderMastersController < ApplicationController
  before_action :set_order_master, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @order_masters = OrderMaster.all
    respond_with(@order_masters)
  end

  def show

    alldropdowns 
           
    @customer = Customer.find(@order_master.customer_id)
    @customer_address = CustomerAddress.new

    if @order_master.customer_address_id.present?
      @customer_address = CustomerAddress.find(@order_master.customer_address_id) 
    end
      @order_lines = OrderLine.where(orderid: @order_master.id)

     @order_line = OrderLine.new
     @order_line.orderid = @order_master.id
    
     @customer_credit_cards = CustomerCreditCard.where(customer_id: @order_master.customer_id)
    @customer_credit_card = CustomerCreditCard.new
    @customer_credit_card.customer_id = @order_master.customer_id
    if @customer_credit_cards.present?
      @customer_credit_card = @customer_credit_cards.last
    
    end

    respond_with(@order_master, @customer, @customer_address, @order_line, @order_lines, @customer_credit_card)


  end

  def new
    @order_master = OrderMaster.new
    respond_with(@order_master)
  end
  
  
  def edit
  end

  def create
    @order_master = OrderMaster.new(order_master_params)
    @order_master.save
    respond_with(@order_master)
  end

  def update
    @order_master.update(order_master_params)
    respond_with(@order_master)
  end

  def destroy
    @order_master.destroy
    respond_with(@order_master)
  end

  private
  def alldropdowns
      @statelist = State.all
      @productvariantlist = ProductVariant.where('activeid = ?',  1)
           .joins(:product_master).where("product_masters.productactivecodeid = ?", 1)
  end

   
    def set_order_master
      @order_master = OrderMaster.find(params[:id])
    end

    def order_master_params
      params.require(:order_master).permit(:orderdate, :employeecode, :employee_id, :customer_id, :customer_address_id, :billno, :external_order_no, :pieces, :subtotal, :taxes, :shipping, :codcharges, :total, :orderstatusmaster_id, :orderpaymentmode_id, :campaignplaylist_id, :notes)
    end
end
