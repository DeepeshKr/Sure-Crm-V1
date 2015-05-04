class OrderLinesController < ApplicationController
  before_action :set_order_line, only: [:show, :edit, :update, :destroy, :deleteupsell, :update_description]

  respond_to :html

  autocomplete :product_variant, :name, :extra_data => [:total, :price, :taxes], full: true, :display_value => :productinfo
     
  autocomplete :product_list, :name, full: true, :display_value => :name, :where => { :active_status_id => 10000} 

  autocomplete :product_variant, :description, :extra_data => [:total, :name], full: true

  def index
    @order_lines = OrderLine.all.order("id DESC").limit(20)
    respond_with(@order_lines)
  end

  def show
    respond_with(@order_line)
  end

  def new
    @order_line = OrderLine.new
    respond_with(@order_line.order_master)
  end

  def edit
  end

  def create
    @order_line = OrderLine.new(employeecode: @empcode, employee_id: @empid,
                    orderlinestatusmaster_id: 1, orderid: order_line_params[:orderid],
                     pieces:  order_line_params[:pieces],
                     orderdate: Time.now, 
            productvariant_id: order_line_params[:productvariant_id],
            product_list_id: order_line_params[:product_list_id])

    if @order_line.valid?

        @order_lines = OrderLine.where("productvariant_id = ? AND orderid = ?", order_line_params[:productvariant_id], order_line_params[:orderid])
        #exorderline = OrderLine.where(productvariant_id: order_line_params[:productvariant_id] && OrderLine.orderid: ) 

        if @order_lines.present?
            pieces = @order_lines.first.pieces
            @order_lines.first.update(pieces: pieces + order_line_params[:pieces].to_i)
            @order_line = @order_lines.first
            flash[:success] = "Product Pieces successfully added " 
          else
            @order_line.save
            flash[:success] = "Product successfully added " 
        end 
     else
        flash[:error] = @order_line.errors.full_messages.join("<br/>")
     end

    respond_with(@order_line.order_master)
        
     
    
  end

  def update_description
      #params[:id]
     productvariant_id = params[:productvariant_id]
      productv = ProductVariant.find(productvariant_id)
      @order_line.update(description: productv.name)

      respond_with(@order_lines)
  end

  def update
    @order_line.update(order_line_params)
    respond_with(@order_line.order_master)
  end

  def destroy
    @order_line.destroy
    #respond_with(@order_line.order_master)
    redirect_to neworder_path(:order_id => @order_line.orderid)  
  end

  def deleteupsell

    @order_line.destroy
    #respond_with(@order_line.order_master)
    redirect_to upsell_path(:order_id => @order_line.orderid)  
  end

  private
    def set_order_line
      @order_line = OrderLine.find(params[:id])
    end

    def order_line_params
      params.require(:order_line).permit(:orderid, :orderdate, :employeecode, :employee_id, 
        :external_ref_no, :productvariant_id, :pieces, :subtotal, :taxes, 
        :shipping, :codcharges, :total, :orderlinestatusmaster_id, :productline_id,
         :description, :estimatedshipdate, :estimatedarrivaldate, :orderchecked,
          :actualshippate, :product_list_id)
    end
end
