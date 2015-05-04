class OrderMastersController < ApplicationController
  before_action :set_order_master, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @order_masters = OrderMaster.all.order("id DESC").limit(100)
    respond_with(@order_masters)
  end

  def list
    @employees = Employee.all.order("first_name").joins(:employee_role).where("employee_roles.sortorder > 8")

    if params[:employee_id].present?
      @employee_id = params[:employee_id]
      @order_masters = OrderMaster.where(employee_id: @employee_id).order("id DESC").limit(100)
    elsif params[:completed].present?
      if params[:completed] = 'yes'
        @order_masters = OrderMaster.where('external_order_no IS NOT NULL').order("id DESC").limit(400)
      end
    else
        
       @order_masters = OrderMaster.order("id DESC").limit(100)
    end

   
     
    respond_with(@order_masters)
  end

  def show

    alldropdowns 
    if @order_master.customer_id.present?
      @customer = Customer.find(@order_master.customer_id)
            
    end
        @customer_address = CustomerAddress.new

    if @order_master.customer_address_id.present?
      @customer_address = CustomerAddress.find(@order_master.customer_address_id) 
    end

     if @order_master.campaign_playlist_id.present?
    @campaign_playlist = CampaignPlaylist.find(@order_master.campaign_playlist_id)
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
      params.require(:order_master).permit(:orderdate, :employeecode, :employee_id, 
        :customer_id, :customer_address_id, :billno, :external_order_no, :pieces, 
        :subtotal, :taxes, :shipping, :codcharges, :total, :order_status_master_id, 
        :orderpaymentmode_id, :campaign_playlist_id, :notes, :order_source_id,
        :media_id, :corporate_id, :order_for_id, :userip, :sessionid, :calledno
        )
    end
end
