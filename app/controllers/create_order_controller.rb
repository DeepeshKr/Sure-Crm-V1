class CreateOrderController < ApplicationController
	#include Wicked::Wizard

	before_action :get_variables, only: [:index, :add_customer, :add_order, :show_media, :add_media, 
    :show_products, :add_products, :show_payment, :add_payment, :new_order, :update_order, 
    :order_summary, :show_address, :add_address, :show_addonproducts, :add_addonproducts, 
    :update_address, :order_review, :order_process]
	before_action :set_order, only: [:order_summary, :show_media,  :show_media, :add_media, :show_products, 
    :add_products, :show_payment, :add_payment, :add_credit_card, :show_addonproducts, :add_addonproducts, :show_address, :add_address, 
    :update_address, :order_review, :order_process ]
  before_action :check_order, only: [:show_media, :add_media, :show_products, :add_products, :show_payment, :add_payment, :update_order, 
    :show_address, :add_address, :update_address, :show_addonproducts, :add_addonproducts, :order_review]

	before_action :productlist, only: [:show_products, :add_products]

	respond_to :html

	#steps :check_customer, :customer_list, :register_customer, :confirm_campaign, :take_orders, :take_address, :process_order
def index
	@customer = Customer.new
	@customer.mobile = @mobile
	@customers = Customer.where('mobile = ?' , @mobile)
	respond_with(@customer, @customers, @order_master)
end

def add_customer
	calledno = params[:calledno]
 	mobile = params[:mobile]
	@customer = Customer.new(customer_params)
	if @customer.save
		new_order_master
		  @order_master.save(:validate => false)
        flash[:success] = "order was created successfully." 
         redirect_to showproducts_path(:order_id => @order_master.id)   
      else
         flash[:error] = @customer.errors.full_messages.join("<br/>")
         redirect_to neworder_path(:mobile => mobile, :calledno => calledno ) 
         #respond_with(@customer, @order_master)
    end
end

def add_order
   	customer_id = params[:customer_id]
  	calledno = params[:calledno]

  #  	@order_master = OrderMaster.new(calledno: calledno, order_status_master_id: 10000,
	 #   	orderdate: Time,zone.now, employeecode: @empcode, employee_id: @empid, order_source_id: 10000,
	 #   	pieces: 0,subtotal: 0, taxes: 0, codcharges: 0, shipping:0, total: 0, 
		# customer_id: customer_id)
    new_order_master
    if	@order_master.save(:validate => false)
		    flash[:success] = "order was created successfully." 
        redirect_to showproducts_path(:order_id => @order_master.id)   
 		else
       flash[:error] = @order_master.errors.full_messages.join("<br/>")
         redirect_to neworder_path(:mobile => mobile, :calledno => calledno ) 
       end
  		#redirect_to :action => 'order_summary'
      #showmedia_path
end

def show_products

@order_lines = OrderLine.where(orderid: @order_master.id)
@order_line = OrderLine.new(orderid: @order_master.id)
@order_line.orderid = @order_master.id
respond_with(@order_master, @order_lines, @order_line)
end

def add_products
exproductlist = ProductList.find(order_line_params[:product_list_id])
exproductvariant = ProductVariant.find(exproductlist.product_variant_id)
@order_lines = OrderLine.where("product_list_id = ? AND orderid = ?", 
  order_line_params[:product_list_id], order_line_params[:orderid])

 product_name = exproductlist.name 
        
        if @order_lines.exists?
            pieces = @order_lines.first.pieces + order_line_params[:pieces].to_i
            @order_lines.first.update(pieces: pieces,
             subtotal: exproductvariant.price * pieces, 
                taxes: exproductvariant.taxes * pieces,
                codcharges: 0,
                shipping: exproductvariant.shipping * pieces,
               total: exproductvariant.total * pieces)
          
            flash[:success] = " #{pieces} Piece/s of #{product_name} successfully added " 
          else
                pieces = order_line_params[:pieces].to_f
                @order_line = OrderLine.create(orderid: order_line_params[:orderid],
                orderdate: Time.zone.now, 
                employeecode: @empcode, employee_id: @empid,
                subtotal: exproductvariant.price * pieces, 
                taxes: exproductvariant.taxes * pieces,
                codcharges: 0,
                shipping: exproductvariant.shipping * pieces,
                pieces:  order_line_params[:pieces],
                total: exproductvariant.total * pieces,
                description: product_name,
                productvariant_id: exproductlist.product_variant_id,
                product_master_id: exproductvariant.productmasterid,
                product_list_id: order_line_params[:product_list_id],
                orderlinestatusmaster_id: 1)
            if @order_line.valid?
                flash[:success] = "#{product_name} successfully added " 
            else
                flash[:error] = @order_line.errors.full_messages.join("<br/>")
            end
        end    


redirect_to showproducts_path(:order_id => @order_master.id)

end

def show_address
  @customer_address = CustomerAddress.new(customer_id:  @order_master.customer_id)
  @customer_address_ex = CustomerAddress.where(customer_id: @order_master.customer_id).last
  if !@order_master.customer_address_id.present?
    @customer_address_ex = @customer_address
  end

  @order_lines = OrderLine.where(orderid: @order_master.id)

  respond_with(@order_master, @order_lines, @customer_address, @customer_address_ex)

end

def add_address
  @customer_address = CustomerAddress.new(customer_address_params)
    if @customer_address.valid?
        @customer_address.save
        @order_master.update(customer_address_id: @customer_address.id)
        flash[:success] = "Order Address is added" 
        redirect_to showmedia_path(:order_id => @order_master.id) 
      else
        flash[:error] = @customer_address.errors.full_messages.join("<br/>")
        redirect_to showaddress_path(:order_id => @order_master.id)  
      end
end

def update_address
  @customer_address = CustomerAddress.where(customer_id: @order_master.customer_id).last
  
        if @customer_address.present?
          @customer_address.update(customer_address_params)
           @order_master.update(customer_address_id: @customer_address.id)
        else
           @customer_address = CustomerAddress.new(customer_address_params)
        end

        if @customer_address.valid?
          @customer_address.save
           @order_master.update(customer_address_id: @customer_address.id)
          flash[:success] = "Order Address is added" 
           redirect_to showmedia_path(:order_id => @order_master.id) 
        else
          flash[:error] = @customer_address.errors.full_messages.join("<br/>")
           redirect_to showaddress_path(:order_id => @order_master.id) 
        end
  
end


def show_media
	mediadropdown
	if (@medialist.count > 1 || @all_calllist.count > 1)
		flash[:error] = "Please select Media there may be more than one " + @medialist.count.to_s  + " Campaign Playlist  " + @all_calllist.count.to_s
    else
      campaignname = "No"
      medianame = "None"

      if @medialist.count > 0
        @order_master.update(media_id: @medialist.first.id)
        medianame = Medium.find(@medialist.first.id).name
      end 	     

      if @all_calllist.count > 0
         @order_master.update(campaign_playlist_id: @all_calllist.first.id)
         campaignname = CampaignPlaylist.find(@all_calllist.first.id).name
      end      

		flash[:success] = " Media #{medianame} added and #{campaignname} Campaign added " 
		redirect_to showaddonproducts_path(:order_id => @order_master.id) 
    end
    
    
end

def add_media
	mediadropdown

	if order_master_params[:media_id].present?
		@order_master.update(:media_id => order_master_params[:media_id])
	end
	if order_master_params[:campaign_playlist_id].present?
		@order_master.update(:campaign_playlist_id => order_master_params[:campaign_playlist_id])
	end
  if params[:mismatched_campaign] = 1
    #Old ad
      interactions(10004)
  elsif params[:mismatched_campaign] = 2
    #Different ad
      interactions(10005)
  end

	if @order_master.valid?
		flash[:success] = "Media added and Campaign Playlist added " 
    	redirect_to showaddonproducts_path(:order_id => @order_master.id) 
	else
         flash[:error] = @order_master.errors.full_messages.join("<br/>")
         redirect_to showmedia_path(:order_id => @order_master.id)  
         #respond_with(@customer, @order_master)
    end

end

def show_addonproducts
  productvariantlist
  addon_product_list
  @order_lines = OrderLine.where(orderid: @order_master.id)
  @order_line = OrderLine.new
  @order_line.orderid = @order_master.id
  respond_with(@order_master, @order_lines, @order_line)
end

def add_addonproducts
  productvariantlist
  addon_product_list
 

  @order_line = OrderLine.new( orderid: order_line_params[:orderid],
  orderdate: Time.now, 
  employeecode: @empcode, employee_id: @empid,
  pieces:  order_line_params[:pieces],
  productvariant_id: order_line_params[:productvariant_id],
  orderlinestatusmaster_id: 1)

  if @order_line.valid?
    @order_lines = OrderLine.where("productvariant_id = ? AND orderid = ?", order_line_params[:productvariant_id], order_line_params[:orderid])
        
        if @order_lines.present?
            pieces = @order_lines.first.pieces
            @order_lines.first.update(pieces: pieces + order_line_params[:pieces].to_i)
            @order_line = @order_lines.first
            flash[:success] = "Product Pieces successfully added " 
          else
            @order_line.save
            flash[:success] = "Product successfully added " 
        end    
  elsif 
    flash[:error] = @order_line.errors.full_messages.join("<br/>")
  end

redirect_to showpayment_path(:order_id => @order_master.id)

end

def show_payment
  @orderpaymentlists = Orderpaymentmode.all
    productvariantlist
    @customer_credit_card_o = CustomerCreditCard.where(customer_id: @order_master.customer_id).last
    @customer_credit_card = CustomerCreditCard.new(customer_id:  @order_master.customer_id)
    @customer_credit_card.name_on_card = @order_master.customer.fullname
    if @customer_credit_card_o.present?
     
      @customer_credit_card.name_on_card = @customer_credit_card_o.name_on_card
    end
    
    @order_lines = OrderLine.where(orderid: @order_master.id)
    @cashondeliveryid = 10001
    orderpaymentmode_1 = Orderpaymentmode.find(@cashondeliveryid).charges

    @cod_charges = @order_master.codcharges 

    cod_amount_i = (@order_master.total.to_i * (1 + orderpaymentmode_1) ).to_i

     @creditcardid = 10000
    orderpaymentmode_2 = Orderpaymentmode.find(@creditcardid).charges
    @order_card_payment_mode_id = Orderpaymentmode.find(@creditcardid).id
     # cod_charge =  OrderPaymentMode.find(1)
     # cc_charge = OrderPaymentMode.find(2)
    #@result = CreditCard.luhn(customer_credit_card_params[:card_no])
    cc_amount_i = (@order_master.total.to_i * (1 +orderpaymentmode_2) ).to_i
    @cod_amount = "Pay Rs #{cod_amount_i} as Cash on Delivery "  
    @cc_amount = "Pay Rs #{cc_amount_i} by Credit Card " 

    respond_with(@order_master, @customer_credit_card_o, @customer_credit_card, @order_lines)
end

def add_credit_card
  @customer_credit_card = CustomerCreditCard.new( customer_id: customer_credit_card_params[:customer_id],
  card_no: customer_credit_card_params[:card_no], 
  name_on_card: customer_credit_card_params[:name_on_card],
  expiry_mon: customer_credit_card_params[:expiry_mon],
  expiry_yr_string:  customer_credit_card_params[:expiry_yr_string])
    #check if card is valid
    result = CreditCard.luhn(customer_credit_card_params[:card_no]) #enter credit card details
    if result == 'valid'
      #update payment as credit card for order
      @order_master.update(orderpaymentmode_id: 2)
      #recalculate on the basis of COD charges as well
      #save card details
      @customer_credit_card.save
      flash[:success] = "Credit Card saved successfully " 
        redirect_to orderreview_path(:order_id => @order_master.id)
    else
       flash[:error] = "Credit Card no is in-valid " 
       redirect_to showpayment_path(:order_id => @order_master.id)
    end
end

def add_payment
  #mode = params[:orderpaymentmode_id]
 
  @order_master.update(orderpaymentmode_id: params[:orderpaymentmode_id])
  if @order_master.valid?
     mode = @order_master.orderpaymentmode.name if @order_master.orderpaymentmode.present?

   # mode = @order_master.orderpaymentmode.name
    flash[:success] = "Payment mode is updated #{mode} " 
      redirect_to orderreview_path(:order_id => @order_master.id) 
  else
    flash[:error] = @order_master.errors.full_messages.join("<br/>")
    redirect_to showpayment_path(:order_id => @order_master.id)  
        #respond_with(@customer, @order_master)
  end
end

def order_review
  #check for address
 
  @show_process = 0
  if @order_master.customer_address_id.nil?
    @show_process = 1
    flash[:error] = "Customer Address is missing " 
  end
  #check for payment mode
  if @order_master.orderpaymentmode_id.nil?
    @show_process = 1
    flash[:error] = " Payment details are missing!" 
  end
  #check for media
  # if @order_master.campaign_playlist_id.nil?
  #   @show_process = 1
  #   flash[:error] = " Campaign playlist is missing " 
  # end
  if @order_master.media_id.nil?
    @show_process = 1
    flash[:error] = " Media is missing " 
  end

  
  @customer_address = CustomerAddress.find(@order_master.customer_address_id)
  @order_id = @order_master.id
  @order_lines = OrderLine.where(orderid: @order_master.id)
  respond_with(@order_master, @order_lines, @customer_address)
end

def order_process
  #this is post 

  #check for address
  if @order_master.customer_address_id.nil?
    flash[:error] = "Customer Address is missing " 
    redirect_to orderreview_path(:order_id => @order_master.id) 
  end
  #check for payment mode
  if @order_master.orderpaymentmode_id.nil?
    flash[:error] = "Payment details are missing!" 
    redirect_to orderreview_path(:order_id => @order_master.id) 
  end
  #check for media
  # if @order_master.campaign_playlist_id.nil?
  #   flash[:error] = "Campaign playlist is missing " 
  #   redirect_to orderreview_path(:order_id => @order_master.id) 
  # end

   if @order_master.media_id.nil?
    flash[:error] = "Media is missing " 
    redirect_to orderreview_path(:order_id => @order_master.id) 
  end
  orderprocessed = update_customer_order_list

 flash[:success] = "The order is successfully processed with id: #{orderprocessed}!"

  @customer_address = CustomerAddress.find(@order_master.customer_address_id)
  @order_id = @order_master.id
  @order_lines = OrderLine.where(orderid: @order_master.id)
 redirect_to ordersummary_path(:order_id => @order_master.id)  
end

def order_summary
  
  @customer_address = CustomerAddress.find(@order_master.customer_address_id)
  @order_id = @order_master.id
  @order_lines = OrderLine.where(orderid: @order_master.id)
	respond_with(@order_master, @order_lines, @customer_address)
end

def show_recentorders
 @order_masters = OrderMaster.where(order_status_master_id: 1).last(10)
  
 # @order_lines = OrderLine.where(orderid: @order_master.id)

  respond_with(@order_masters)
end

private
    def check_order
      orderid = params[:order_id] 

     order_master =  OrderMaster.find(orderid)
     statusno = order_master.order_status_master_id
      ondate = order_master.updated_at.to_s
      if order_master.order_status_master_id >= 10003
       
        flash[:error] = "This order no #{orderid} is already processed at #{ondate}" 
        redirect_to ordersummary_path(:order_id => @order_master.id)
       end
    end

    def new_order_master
      customer_id = params[:customer_id] || @customer.id

      @order_master = OrderMaster.new(calledno: @calledno, order_status_master_id: 10000, 
      orderdate: Time.zone.now, pieces: 0,subtotal: 0, taxes: 0, codcharges: 0, shipping:0, 
      total: 0, order_source_id: 10000, employeecode: @empcode, employee_id: @empid, 
      order_for_id: 10000, customer_id: customer_id)
    end

    
    def get_variables
    	@empcode = current_user.employee_code
    	@empid = current_user.id
        @calledno = params[:calledno]
        @mobile = params[:mobile]
        @force = 'no'
             if params.has_key?(:force)
                @force = params[:force]   
             end
    end

    def mediadropdown
    	@medialist =  Medium.where('telephone = ?', @order_master.calledno)

    	@campaignlist =  Campaign.joins(:medium).where('media.telephone = ?', @order_master.calledno)
            #time_range = (Time.now.midnight - 1.day)..Time.now.midnight
    	@all_calllist = CampaignPlaylist.joins(:campaign)
           .where('campaigns.startdate <= ? and enddate >= ?', DateTime.now, DateTime.now)
           .where.not(productvariantid: nil)
           .where({campaignid: @campaignlist})
    end
    
  	def productlist
       product_masters = ProductMaster.where("productactivecodeid = ?", 10000).pluck("id")
      product_variants = ProductVariant.where("activeid = ? and product_sell_type_id = ?", 10000, 10000).where(productmasterid: product_masters).pluck("id")
  		@productlist = ProductList.where('active_status_id = ?',  10000).where(product_variant_id: product_variants)
      #.joins(:product_variant).where("product_variant.activeid = ?", 10000)
      #.joins(:product_variant => :product_master).where("product_variant.product_masters.productactivecodeid = ?", 10000)
      #.joins(:Source => :SourceType)
  	end

    def addon_product_list
      product_masters = ProductMaster.where("productactivecodeid = ?", 10000).pluck("id")
      product_variants = ProductVariant.where("activeid = ? and product_sell_type_id = ?", 10000, 10001).where(productmasterid: product_masters).pluck("id")
      @productaddonlist = ProductList.where('active_status_id = ?',  10000).where(product_variant_id: product_variants)     
    end


    def interactions(refcatid)
     @intearaction_master = InteractionMaster.create(createdon: Time.now, 
     		interaction_status_id:10000,
          	customer_id: @order_master.customer_id, 
          	callednumber: @order_master.calledno,
          	interaction_category_id:refcatid, 
            orderid: @order_master.id, 
          	interaction_priority_id:10000,
          	campaign_playlist_id: @order_master.campaign_playlist_id, 
          	state: customer_params[:state], resolveby: 2.days.from_now)

          if order_params[:comments].present?
            @interaction_transcripts = @intearaction_master.interaction_transcript.create(description:order_master_params[:comments], interactionuserid:10000, callednumber:calledno)
          end
    end

    def set_customer
      @customer = Customer.find(params[:customer_id])
    end

    def set_order
      @order_master = OrderMaster.find(params[:order_id])
    end

    def customer_params
      params.require(:customer).permit(:salute, :first_name, :last_name, :mobile, 
      :alt_mobile, :emailid, :alt_emailid, :calledno, :orderpaymentmode_id)
    end

  	def order_master_params
        params.require(:order_master).permit(:id, :customer_id, :media_id,
          :campaign_playlist_id, :calledno, :comments, :payment_id, :orderpaymentmode_id, 
          :comments, :mismatched_campaign, :product_list_id)
    end

    def order_line_params
      params.require(:order_line).permit(:orderid, :orderdate, :employeecode, :employee_id, 
        :external_ref_no, :productvariant_id, :pieces, :subtotal, :taxes, 
        :shipping, :codcharges, :total, :orderlinestatusmaster_id, :productline_id,
         :description, :estimatedshipdate, :estimatedarrivaldate, :orderchecked,
          :actualshippate, :orderpaymentmode_id, :product_list_id)
    end

    def customer_credit_card_params
      params.require(:customer_credit_card).permit(:customer_id, :card_no, 
        :name_on_card, :expiry_mon, :expiry_yr_string)
    end

    def customer_address_params
      params.require(:customer_address).permit(:customer_id, :name, :address1, 
        :address2, :address3, :landmark, :city, :pincode, :state, :district, :country, 
        :telephone1, :telephone2, :fax, :description, :valid_id)
    end

    def update_customer_order_list
      creditcardno =  nil
      expmonth = nil
      expyear = nil
      name_on_card = nil
      cardname = nil

      order_id = @order_master.id


      if @order_master.orderpaymentmode_id == 10000
         customer_credit_card = CustomerCreditCard.where(customer_id: @order_master.customer_id).last

        creditcardno =  customer_credit_card.card_no.truncate(20)
        expmonth = customer_credit_card.expiry_mon.truncate(20)
        expyear = customer_credit_card.expiry_yr_string.truncate(20)
        cardtype = CreditCard.find_type(creditcardno).truncate(20)
      end
#
#
if @order_master.external_order_no.nil?
     customer_order_list =  CustomerOrderList.create(ordernum: order_id, orderdate: Time.zone.now,
      title: @order_master.customer.salute.truncate(5), 
      fname: @order_master.customer.first_name.truncate(30), 
      lname: @order_master.customer.last_name.truncate(30), 
      add1: @order_master.customer_address.address1.truncate(30), 
      add2: @order_master.customer_address.address2.truncate(30), 
      add3: (@order_master.customer_address.address3.truncate(30) if @order_master.customer_address.address3.present?), 
      landmark: @order_master.customer_address.landmark.truncate(50), 
      city: @order_master.customer_address.city.truncate(30), 
      state: @order_master.customer_address.state.truncate(5), 
      pincode: @order_master.customer_address.pincode, 
      mstate: @order_master.customer_address.state.truncate(50), 
      tel1: @order_master.customer.mobile.truncate(20), 
      tel2: (@order_master.customer_address.telephone1.truncate(20) if @order_master.customer_address.telephone1.present?),
      fax: (@order_master.customer_address.fax.truncate(20) if @order_master.customer_address.fax.present?), 
      email: (@order_master.customer.emailid.truncate(20) if @order_master.customer.emailid.present?), 
      ccnumber:  creditcardno, 
      expmonth:  expmonth, 
      expyear:  expyear, 
      cardtype: cardtype,
      ipadd: (@order_master.userip.truncate(50) if @order_master.userip.present?), 
      dnis: @order_master.calledno,
      channel: @order_master.medium.name.truncate(50), 
      carddisc: @order_master.creditcardcharges, 
      chqdisc: @order_master.creditcardcharges,
      totalamt: @order_master.subtotal + @order_master.shipping + @order_master.creditcardcharges + @order_master.codcharges + @order_master.maharastraextra,
      trandate: Time.zone.now)
      
     orderline1 = OrderLine.where("orderid = ?", order_id)
      if orderline1.exists?
        customer_order_list.update(prod1: orderline1.first.product_variant.extproductcode, qty1: orderline1.first.pieces)
      end
      orderline2 = OrderLine.where("orderid = ?", order_id).offset(1)
      if orderline2.exists?
        customer_order_list.update(prod2: orderline2.first.product_variant.extproductcode, qty2: orderline2.first.pieces)
      end
      orderline3 = OrderLine.where("orderid = ?", order_id).offset(2)
      if orderline3.exists?
        customer_order_list.update(prod3: orderline3.first.product_variant.extproductcode, qty3: orderline3.first.pieces)
      end
      orderline4 = OrderLine.where("orderid = ?", order_id).offset(3)
      if orderline4.exists?
        customer_order_list.update(prod4: orderline4.first.product_variant.extproductcode, qty4: orderline4.first.pieces)
      end
      orderline5 = OrderLine.where("orderid = ?", order_id).offset(4)
      if orderline5.exists?
        customer_order_list.update(prod5: orderline5.first.product_variant.extproductcode, qty5: orderline5.first.pieces)
      end
      orderline6 = OrderLine.where("orderid = ?", order_id).offset(5)
      if orderline6.exists?
        customer_order_list.update(prod6: orderline6.first.product_variant.extproductcode, qty6: orderline6.first.pieces)
      end
      orderline7 = OrderLine.where("orderid = ?", order_id).offset(6)
      if orderline7.exists?
        customer_order_list.update(prod7: orderline7.first.product_variant.extproductcode, qty7: orderline7.first.pieces)
      end
      orderline8 = OrderLine.where("orderid = ?", order_id).offset(7)
      if orderline8.exists?
        customer_order_list.update(prod8: orderline8.first.product_variant.extproductcode, qty8: orderline8.first.pieces)
      end
      orderline9 = OrderLine.where("orderid = ?", order_id).offset(8)
      if orderline9.exists?
        customer_order_list.update(prod9: orderline9.first.product_variant.extproductcode, qty9: orderline9.first.pieces)
      end
      orderline10 = OrderLine.where("orderid = ?", order_id).offset(9)
      if orderline10.exists?
        customer_order_list.update(prod10: orderline10.first.product_variant.extproductcode, qty10: orderline10.first.pieces)
      end

      #- Integer update with customer order id
      @order_master.update(external_order_no: customer_order_list.id.to_s, order_status_master_id: 10003) 

      return customer_order_list.id
      #external_order_no - string update with customer order id
        else
          customer_order_list = CustomerOrderList.find(@order_master.external_order_no.to_i)
      
      customer_order_list.update(ordernum: order_id, orderdate: Time.zone.now,
      title: @order_master.customer.salute.truncate(5), 
      fname: @order_master.customer.first_name.truncate(30),
      lname: @order_master.customer.last_name.truncate(30),  
      add1: @order_master.customer_address.address1.truncate(30), 
      add2: @order_master.customer_address.address2.truncate(30), 
      add3: (@order_master.customer_address.address3.truncate(30) if @order_master.customer_address.address3.present?), 
      landmark: @order_master.customer_address.landmark.truncate(50), 
      city: @order_master.customer_address.city.truncate(30), 
      state: @order_master.customer_address.state.truncate(5), 
      pincode: @order_master.customer_address.pincode, 
      mstate: @order_master.customer_address.state.truncate(50), 
      tel1: @order_master.customer.mobile.truncate(20), 
      tel2: (@order_master.customer_address.telephone1.truncate(20) if @order_master.customer_address.telephone1.present?),
      fax: (@order_master.customer_address.fax.truncate(20) if @order_master.customer_address.fax.present?), 
      email: (@order_master.customer.emailid.truncate(20) if @order_master.customer.emailid.present?), 
      ccnumber:  creditcardno, 
      expmonth:  expmonth, 
      expyear:  expyear, 
      cardtype: cardtype,
      ipadd: (@order_master.userip.truncate(50) if @order_master.userip.present?), 
      dnis: @order_master.calledno,
      channel: @order_master.medium.name.truncate(50), 
      carddisc: @order_master.creditcardcharges, 
      chqdisc: @order_master.creditcardcharges,
      totalamt: @order_master.subtotal + @order_master.shipping + @order_master.creditcardcharges + @order_master.codcharges + @order_master.maharastraextra,
      trandate: Time.zone.now)     

      
      orderline1 = OrderLine.where("orderid = ?", order_id)
      if orderline1.exists?
        customer_order_list.update(prod1: orderline1.first.product_variant.extproductcode, qty1: orderline1.first.pieces)
      end
      orderline2 = OrderLine.where("orderid = ?", order_id).offset(1)
      if orderline2.exists?
        customer_order_list.update(prod2: orderline2.first.product_variant.extproductcode, qty2: orderline2.first.pieces)
      end
      orderline3 = OrderLine.where("orderid = ?", order_id).offset(2)
      if orderline3.exists?
        customer_order_list.update(prod3: orderline3.first.product_variant.extproductcode, qty3: orderline3.first.pieces)
      end
      orderline4 = OrderLine.where("orderid = ?", order_id).offset(3)
      if orderline4.exists?
        customer_order_list.update(prod4: orderline4.first.product_variant.extproductcode, qty4: orderline4.first.pieces)
      end
      orderline5 = OrderLine.where("orderid = ?", order_id).offset(4)
      if orderline5.exists?
        customer_order_list.update(prod5: orderline5.first.product_variant.extproductcode, qty5: orderline5.first.pieces)
      end
      orderline6 = OrderLine.where("orderid = ?", order_id).offset(5)
      if orderline6.exists?
        customer_order_list.update(prod6: orderline6.first.product_variant.extproductcode, qty6: orderline6.first.pieces)
      end
      orderline7 = OrderLine.where("orderid = ?", order_id).offset(6)
      if orderline7.exists?
        customer_order_list.update(prod7: orderline7.first.product_variant.extproductcode, qty7: orderline7.first.pieces)
      end
      orderline8 = OrderLine.where("orderid = ?", order_id).offset(7)
      if orderline8.exists?
        customer_order_list.update(prod8: orderline8.first.product_variant.extproductcode, qty8: orderline8.first.pieces)
      end
      orderline9 = OrderLine.where("orderid = ?", order_id).offset(8)
      if orderline9.exists?
        customer_order_list.update(prod9: orderline9.first.product_variant.extproductcode, qty9: orderline9.first.pieces)
      end
      orderline10 = OrderLine.where("orderid = ?", order_id).offset(9)
      if orderline10.exists?
        customer_order_list.update(prod10: orderline10.first.product_variant.extproductcode, qty10: orderline10.first.pieces)
      end

      #process only that order which is not processed
   
      if @order_master.order_status_master_id < 10003
       @order_master.update( order_status_master_id:10003 ) 
      end    

      return customer_order_list.id

        end


    end
end


