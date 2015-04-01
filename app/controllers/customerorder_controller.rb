class CustomerorderController < ApplicationController

before_action :productlist, only: [:products, :offline, :add_products]
before_action :order_line_params, only: [ :add_products]
before_action :set_order
before_action :new_call
#before_action :check_order, except: [:summary] 
before_action :customer_address, only: [ :upsell, :payment, :channel, :review, :summary]
before_action :customer, only: [ :upsell, :payment, :channel, :review, :summary]

  respond_to :html

#first Step is where the customer number and called no are shown together

  def products
    new_call
    #if order is not null then create orderline with order id
   
    @order_line = OrderLine.new()
  
    if @order_id.present?
        @order_line.orderid = @order_id  
        addon_product_lists  
    end

  respond_with(@order_master, @order_lines, @order_line)
  end

  def offline
    new_call
    #if order is not null then create orderline with order id
    @user_file_name = 'z:/filename.cli'
    @order_line = OrderLine.new()
  
    if @order_id.present?
        @order_line.orderid = @order_id  
        addon_product_lists  
    end

  respond_with(@order_master, @order_lines, @order_line)
  end
  def upload

  end

  def add_products
    new_call
    orderid = 0
    
    #check if order id present else create new order id using this process
    #check if order created else create new
    if params[:order_id].present?
       @order_id =  order_line_params[:orderid]
     else
      @order_id = neworder

       order_line_params[:orderid] = @order_id
       
    end
    #orderid = @order_id
    #flash[:notice] = "Order id is created #{orderid} called from numer #{@mobile} to number #{@calledno}" 
    #flash[:error] = @order_master.errors.full_messages.join("<br/>")
    exproductlist = ProductList.find(order_line_params[:product_list_id])
    exproductvariant = ProductVariant.find(exproductlist.product_variant_id)
    @order_lines = OrderLine.where("product_list_id = ? AND orderid = ?", 
    order_line_params[:product_list_id], @order_id)

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
                @order_line = OrderLine.create(orderid: @order_id,
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
                orderlinestatusmaster_id: 10000)
            if @order_line.valid?
                flash[:success] = "#{product_name} successfully added " 
            else
                flash[:error] = @order_line.errors.full_messages.join("<br/>")
            end
        end    


      redirect_to neworder_path(:order_id => @order_id)

  end

  def add_basic_upsell
     exproductlist = ProductList.find(params[:product_list_id])
      exproductvariant = ProductVariant.find(exproductlist.product_variant_id)
      @order_lines = OrderLine.where("product_list_id = ? AND orderid = ?", 
      params[:product_list_id], params[:order_id])

      product_name = exproductlist.productlistdetails 
        
        if @order_lines.exists?
            pieces = @order_lines.first.pieces + params[:pieces].to_i
            @order_lines.first.update(pieces: pieces,
             subtotal: exproductvariant.price * pieces, 
                taxes: exproductvariant.taxes * pieces,
                codcharges: 0,
                shipping: exproductvariant.shipping * pieces,
               total: exproductvariant.total * pieces)
          
            flash[:success] = " #{pieces} Piece/s of #{product_name} successfully added " 
          else
                pieces = params[:pieces].to_f
                @order_line = OrderLine.create(orderid: params[:order_id],
                orderdate: Time.zone.now, 
                employeecode: @empcode, employee_id: @empid,
                subtotal: exproductvariant.price * pieces, 
                taxes: exproductvariant.taxes * pieces,
                codcharges: 0,
                shipping: exproductvariant.shipping * pieces,
                pieces:  params[:pieces],
                total: exproductvariant.total * pieces,
                description: product_name,
                productvariant_id: exproductlist.product_variant_id,
                product_master_id: exproductvariant.productmasterid,
                product_list_id: params[:product_list_id],
                orderlinestatusmaster_id: 10000)
            if @order_line.valid?
                flash[:success] = "#{product_name} successfully added " 
            else
                flash[:error] = @order_line.errors.full_messages.join("<br/>")
            end
        end    
      redirect_to neworder_path(:order_id => @order_master.id) 

  end

  def address
    
  #@order_lines = OrderLine.where(orderid: @order_master.id)
  # @mobile = @order_master.mobile || 99225533

  #@customer = Customer.new(mobile: @order_master.mobile)
  #use this for nested address
  #customer_address = @customer.customer_address.build(telephone1: @customer.mobile)
  if @order_master.customer_id.present?
    @customer = Customer.find(@order_master.customer_id)
      success = "Existing Customer found." 
  elsif Customer.where(mobile: @order_master.mobile).present?
    @customer = Customer.where(mobile: @order_master.mobile).last
     success = "Existing Customer found." 
  else
    @customer = Customer.new(mobile: @order_master.mobile)
    notice = "No customer found." 
  end

  if @order_master.customer_address_id.present?
    @customer_address = CustomerAddress.find(@order_master.customer_address_id)
     success = " Existing address is available" 
  elsif CustomerAddress.where(telephone1: @order_master.mobile).present?
    @customer_address = CustomerAddress.where(telephone1: @order_master.mobile).last
     success = "Existing address found." 
  else
    @customer_address = CustomerAddress.new(telephone1: @order_master.mobile)
     notice = "No address found." 
  end

  flash[:notice] = "#{notice}"

  flash[:success] = "#{success}"

  respond_with(@order_master, @order_lines, @customer_address, @customer)

  end

  def add_address

    if params[:customer_id].present?
      @customer = Customer.find(params[:customer_id])
      @customer.update(salute:  params[:customer_salute], 
      first_name: params[:customer_first_name],
      last_name: params[:customer_last_name],
       mobile: params[:customer_mobile], 
      alt_mobile: params[:customer_alt_mobile],
      emailid: params[:customer_emailid])
    else
       @customer = Customer.create(salute:  params[:customer_salute] , 
      first_name: params[:customer_first_name]  ,
      last_name: params[:customer_last_name] ,
       mobile: params[:customer_mobile] , 
      alt_mobile: params[:customer_alt_mobile],
      emailid: params[:customer_emailid])
    end
   
    @order_master.update(customer_id: @customer.id)

    if params[:customer_address_id].present?
       @customer_address = CustomerAddress.find(params[:customer_address_id])
       @customer_address.update(customer_address_params)
        @customer_address.update(customer_id: @customer.id)
    else
      @customer_address = CustomerAddress.new(customer_address_params)
      @customer_address.save
    end

    @order_master.update(customer_address_id: @customer_address.id)

    redirect_to upsell_path(:order_id => @order_id)
  end

  def upsell
    product_list_ids = OrderLine.where(orderid: @order_master.id).pluck(:product_list_id)
     product_masters = ProductMaster.where("productactivecodeid = ?", 10000).pluck("id")
     product_variants = ProductVariant.where("activeid = ? and product_sell_type_id = ?", 10000, 10001).where(productmasterid: product_masters).pluck("id")
     @productaddonlists = ProductList.where('active_status_id = ?',  10000).where(product_variant_id: product_variants).where('id not in (?)',product_list_ids)     

    respond_with(@order_master, @order_lines, @customer, @customer_address, @productaddonlists)
  end

  def add_upsell
      exproductlist = ProductList.find(params[:product_list_id])
      exproductvariant = ProductVariant.find(exproductlist.product_variant_id)
      @order_lines = OrderLine.where("product_list_id = ? AND orderid = ?", 
      params[:product_list_id], params[:order_id])

      product_name = exproductlist.productlistdetails 
        
        if @order_lines.exists?
            pieces = @order_lines.first.pieces + params[:pieces].to_i
            @order_lines.first.update(pieces: pieces,
             subtotal: exproductvariant.price * pieces, 
                taxes: exproductvariant.taxes * pieces,
                codcharges: 0,
                shipping: exproductvariant.shipping * pieces,
               total: exproductvariant.total * pieces)
          
            flash[:success] = " #{pieces} Piece/s of #{product_name} successfully added " 
          else
                pieces = params[:pieces].to_f
                @order_line = OrderLine.create(orderid: params[:order_id],
                orderdate: Time.zone.now, 
                employeecode: @empcode, employee_id: @empid,
                subtotal: exproductvariant.price * pieces, 
                taxes: exproductvariant.taxes * pieces,
                codcharges: 0,
                shipping: exproductvariant.shipping * pieces,
                pieces:  params[:pieces],
                total: exproductvariant.total * pieces,
                description: product_name,
                productvariant_id: exproductlist.product_variant_id,
                product_master_id: exproductvariant.productmasterid,
                product_list_id: params[:product_list_id],
                orderlinestatusmaster_id: 10000)
            if @order_line.valid?
                flash[:success] = "#{product_name} successfully added " 
            else
                flash[:error] = @order_line.errors.full_messages.join("<br/>")
            end
        end    
      redirect_to upsell_path(:order_id => @order_master.id) 
  end

  def payment
    
    if @order_master.customer_address_id.blank?
      flash[:error] = "No Address found you need to add / save address before you process payment " << Time.zone.now.to_s
        return redirect_to address_path(:order_id => @order_master.id) 
    end
    # @orderpaymentlists = Orderpaymentmode.all
    # productlist
    
    @customer_credit_card_o = CustomerCreditCard.where(customer_id: @order_master.customer_id).last
    @customer_credit_card = CustomerCreditCard.new(customer_id:  @order_master.customer_id)
    #@customer_credit_card.name_on_card = @order_master.customer.name
    # if @customer_credit_card_o.present?
    #   @customer_credit_card.name_on_card = @order_master.customer.fullname
    # end
    
    @cashondeliveryid = 10001
    orderpaymentmode_1 = Orderpaymentmode.find(@cashondeliveryid).charges

   
    cod_amount_i = @order_master.subtotal + @order_master.shipping + @order_master.codcharges + @order_master.servicetax + @order_master.maharastracodextra

     @creditcardid = 10000
    orderpaymentmode_2 = Orderpaymentmode.find(@creditcardid).charges
    @order_card_payment_mode_id = Orderpaymentmode.find(@creditcardid).id
     # cod_charge =  OrderPaymentMode.find(1)
     # cc_charge = OrderPaymentMode.find(2)
    #@result = CreditCard.luhn(customer_credit_card_params[:card_no])

    cc_amount_i = (@order_master.subtotal + @order_master.shipping + @order_master.creditcardcharges + @order_master.maharastraccextra).to_i
    
    @paidover = "This order is Not Paid."

      @cod_amount = "Pay Rs #{cod_amount_i} "  
      @cc_amount = "Pay Rs #{cc_amount_i}" 


     #check if paid using credit card is selected
  if @order_master.orderpaymentmode_id.present?
     if @order_master.orderpaymentmode_id == 10000 #paid over CC
      @paidover = "Paid using Credit Card, you saved on extra charges"

        @cod_amount = "Pay Rs #{cod_amount_i}. "  
        @cc_amount = "Rs #{cc_amount_i}  " 
        
   elsif @order_master.orderpaymentmode_id == 10001 #paid over COD
     @paidover = "Paid over Cash on Delivery, Save on extra charges if paid over Credit Card"

      @cod_amount = "Rs #{cod_amount_i}"  
      @cc_amount = "Pay Rs #{cc_amount_i}" 
     end
  end


    
    respond_with(@order_master, @order_lines,  @customer_credit_card_o, @customer_credit_card)
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
      @order_master.update(orderpaymentmode_id: params[:orderpaymentmode_id])
      #recalculate on the basis of COD charges as well
      #save card details
      @customer_credit_card.save
      flash[:success] = "Credit Card saved successfully " 
      redirect_to channel_path(:order_id => @order_master.id)
    else
       flash[:error] = "Credit Card no is in-valid " 
       redirect_to payment_path(:order_id => @order_master.id)
    end
end

def add_payment
  #mode = params[:orderpaymentmode_id]
 
  @order_master.update(orderpaymentmode_id: params[:orderpaymentmode_id])
  if @order_master.valid?
     mode = @order_master.orderpaymentmode.name if @order_master.orderpaymentmode.present?

   # mode = @order_master.orderpaymentmode.name
    flash[:success] = "Payment mode is updated #{mode} " 
      redirect_to channel_path(:order_id => @order_master.id) 
  else
    flash[:error] = @order_master.errors.full_messages.join("<br/>")
    redirect_to showpayment_path(:order_id => @order_master.id)  
        #respond_with(@customer, @order_master)
  end
end

  def channel
      @medialist =  Medium.where('dnis = ?', @order_master.calledno)

        if @medialist.count == 1   #&& @all_calllist.empty?
          @order_master.update(media_id: @medialist.first.id)
          medianame = @medialist.first.name

          add_product_to_campaign(@medialist.first.id)
          flash[:success] = " Media #{medianame} added added " 
          return redirect_to review_path(:order_id => @order_master.id)
        end

        if Medium.where('dnis = ? and state = ?', @order_master.calledno, @order_master.customer_address.state.upcase).present?
          @newmedialist = Medium.where('dnis = ? and state = ?', @order_master.calledno, @order_master.customer_address.state.upcase)  
          @order_master.update(media_id: @newmedialist.first.id)
          medianame = @newmedialist.first.name

          add_product_to_campaign(@newmedialist.first.id)
          flash[:success] = " Media #{medianame} added added " 
          return redirect_to review_path(:order_id => @order_master.id)
        end

      if @medialist.count > 1 
        #check for state here
        # if @medialist.where("state <> '' or state is not null")
        #  @medialist = @medialist.where('state = ?', @order_master.customer_address.state.upcase)
        # end
      end

campaignlist =  Campaign.where('TRUNC(startdate) <=  ? and TRUNC(enddate) >= ?', Date.today, Date.today)
  
  noof = campaignlist.count || "None" if campaignlist.present?
  
     todaydate = Date.today
 #flash[:success] = "today's date #{todaydate} and there are #{noof}" 
    #media found and no campaign playlists found, just go to review
    #for media we use DNIS and State details
        
         # the new code goes here with the details of the products and last played 
         #once the media has been fixed then make sure the campaign is selected 
         #based on what product has been selected by the customer 
     
    
     # flash[:error] = "Please select Channel there may be more than one " + @medialist.count.to_s   
   
    respond_with(@order_master, @order_lines, @customer, @customer_address)
  end

  def add_channel


  if order_master_params[:media_id].present?
    @order_master.update(:media_id => order_master_params[:media_id])

    add_product_to_campaign(order_master_params[:media_id])
  end
  
  if @order_master.valid?
    flash[:success] = "Channel successfully added " 
      redirect_to review_path(:order_id => @order_master.id) 
  else
         flash[:error] = @order_master.errors.full_messages.join("<br/>")
         redirect_to channel_path(:order_id => @order_master.id)  
         #respond_with(@customer, @order_master)
    end

end

  def review
     @show_process = 0

     if @order_master.total < 100
          @show_process = 1
          flash[:error] = "The Order value is too low to be processed" 
     end
     if @order_master.customer_address_id.nil?
          @show_process = 1
          flash[:error] = "Customer Address is missing " 
      end
      #check for payment mode
      if @order_master.orderpaymentmode_id.nil?
        @show_process = 1
        flash[:error] = " Payment details are missing!" 
      end
  
      if @order_master.media_id.nil?
        @show_process = 1
        flash[:error] = " Media is missing " 
      end

    
    customer
    respond_with(@order_master, @order_lines, @customer, @customer_address)
  end

  def process_order
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
      if @order_master.media_id.nil?
        flash[:error] = "Media is missing " 
        redirect_to orderreview_path(:order_id => @order_master.id) 
      end
      orderprocessed = update_customer_order_list

     flash[:success] = "The order is successfully processed with id: #{orderprocessed}"

     
     redirect_to summary_path(:order_id => @order_master.id) 

  end
  def summary
     customer
     @cust_details_id = @order_master.external_order_no
    respond_with(@order_master, @order_lines, @customer, @customer_address)
  end

  #other menus
  def new_dealer
    @customer = Customer.new(mobile: @mobile)
    @interaction_master = InteractionMaster.all
    @interactioncategorylist =  InteractionCategory.where("sortorder >= 10")
    @interactionprioritylist =  InteractionPriority.all
    respond_with(@interaction_master, @customer)
  end

  def created_new_dealer

  end

  def dealers

 #@customer = Customer.find(@order_master.customer_id)
 @states = ADDRESS_DEALER.select(:state).distinct

if params[:from_state].present?
  @state = params[:from_state]
  @address_dealer = ADDRESS_DEALER.where(state: @state)
  state_c = @state.capitalize
  nos = @address_dealer.count
  @state_searched = "Search for #{state_c} and found #{nos}"
  @cities = @address_dealer.select(:add3).distinct
  if params[:city].present?
    @address_dealer = @address_dealer.where(add3:params[:city])
    state_c = params[:city].capitalize << " in " << @state.capitalize 
    nos = @address_dealer.count
    @state_searched = "#{state_c} and found #{nos}"    
  end

end
    respond_with(@cities, @address_dealer)
  end



  private

    def add_product_to_campaign(mediumid)

         product_variant_id = OrderLine.where(orderid: @order_master.id).order("id").pluck(:productvariant_id).first

     # product_variant_id = productvariants

          t = Time.zone.now
          nowhour = t.strftime('%H').to_i
          #=> returns a 0-padded string of the hour, like "07"
          nowminute = t.strftime('%M').to_i
          #=> returns a 0-padded string of the minute, like "03"
          #flash[:notice] = "Hours #{nowhour} and minutes #{nowminute}"
          #campaignlist =  Campaign.where('mediumid = ? and startdate <= ? and enddate >= ?',  mediumid, Time.zone.now.to_date, Time.zone.now.to_date)
         
          campaignlist =  Campaign.where(mediumid: mediumid).where('TRUNC(startdate) <=  ? and TRUNC(enddate) >= ?', Date.today, Date.today)
            #time_range = (Time.now.midnight - 1.day)..Time.now.midnight 
            #list_status_id = ?, 1000
            # .where('campaigns.startdate = ?', Time.zone.now.to_date)
            # 
            # .joins(:campaign).where('campaigns.startdate <= ? and enddate >= ?', Time.zone.now.to_date)
            #   
            #  
            # .joins(:campaign).where("campaign.mediumid = ? ", mediumid)

          all_calllist = CampaignPlaylist.where({campaignid: campaignlist}).where(list_status_id: 10000).order("id DESC").where("start_hr <= ? and start_min <= ?", nowhour, nowminute).where(productvariantid: product_variant_id)

        camdate = "No list found"
         todaydate = Date.today
        
          productvariant = ProductVariant.find(product_variant_id).name

            if all_calllist.count > 0
              camdate = campaignlist.first.startdate
               namecamp = all_calllist.first.name << " " << campaignlist.first.name
               campaignplaylist = CampaignPlaylist.find(campaignlist.first.id).name
              @order_master.update(campaign_playlist_id: campaignlist.first.id)
              
              #flash[:notice] = " Product #{productvariant} added to playlist #{namecamp} for camp date #{camdate} while today is #{todaydate}" 
             # else
              # namecamp = "Nothing in list" << " Campaign " << camdate

              #flash[:error] = " Unable to add Product #{productvariant} to any playlist tried for #{namecamp} for camp date #{camdate} while today is #{todaydate}"   
            end


    end

    def new_call
      set_order
      @calledno = params[:calledno] #|| if params[:calledno].present?
      @mobile = params[:mobile] #|| if params[:mobile].present?
      if params[:order_id].present?
       @order_id = params[:order_id] 
       @customer_id = @order_master.customer_id 
       @calledno = @order_master.calledno
       @mobile = @order_master.mobile
      end
      
      @empcode = current_user.employee_code
      @empid = current_user.id
          
      @interactioncategorylist =  InteractionCategory.where("sortorder < 100")
      @interactiondisposelist =  InteractionCategory.where("sortorder < 100")
      @interactionprioritylist =  InteractionPriority.all
      
    end

    def neworder
      @order_master = OrderMaster.create!(calledno: @calledno, order_status_master_id: 10000, 
        orderdate: Time.zone.now, pieces: 0,subtotal: 0, taxes: 0, codcharges: 0, shipping:0, 
        total: 0, order_source_id: 10000, employeecode: @empcode, employee_id: @empid, 
        userip: request.remote_ip, sessionid: session.id,
        order_for_id: 10000, mobile: @mobile)

      return @order_master.id
    end

    def customer
      if @order_master.customer_id.present?
        @customer = Customer.find(@order_master.customer_id)
      end
    end

    def customer_address
      if @order_master.customer_address_id.present?
        @customer_address = CustomerAddress.find(@order_master.customer_address_id)
      end       
    end

    def set_order
      if params[:order_id].present?
          @order_master = OrderMaster.find(params[:order_id])
          @order_lines = OrderLine.where(orderid: params[:order_id])
      end
    end

    def customer_params
      params.require(:customer).permit(:salute, :first_name, :last_name, :mobile, 
      :alt_mobile, :emailid, :alt_emailid, :calledno)
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
        :telephone1, :telephone2, :fax, :description, :valid_id, :customer_address_id)
    end

    def productlist
      product_masters = ProductMaster.where("productactivecodeid = ?", 10000).pluck("id")
      product_variants = ProductVariant.where("activeid = ? and product_sell_type_id = ?", 10000, 10000).where(productmasterid: product_masters).pluck("id")
      @productlist = ProductList.where('active_status_id = ?',  10000).where(product_variant_id: product_variants).joins(:product_variant).order("product_variants.name")
    
      specific_addon_product_list
    end

    def addon_product_list
      product_masters = ProductMaster.where("productactivecodeid = ?", 10000).pluck("id")
      product_variants = ProductVariant.where("activeid = ? and product_sell_type_id = ?", 10000, 10001).where(productmasterid: product_masters).pluck("id")
      @productaddonlist = ProductList.where('active_status_id = ?',  10000).where(product_variant_id: product_variants).joins(:product_variant).order("product_variants.name")  

      @productaddonlists = ProductList.where('active_status_id = ?',  10000).where(product_variant_id: product_variants).where('id not in (?)',product_list_ids)  
    end

     def specific_addon_product_list
      product_masters = ProductMaster.where("productactivecodeid = ?", 10000).pluck("id")
      product_variants = ProductVariant.where("activeid = ? and product_sell_type_id = ?", 10000, 10040).where(productmasterid: product_masters).pluck("id")
      @productaddonlist = ProductList.where('active_status_id = ?',  10000).where(product_variant_id: product_variants).joins(:product_variant).order("product_variants.name")     
    end

    def addon_product_lists
   # @product_master_add_ons = ProductList.all
    @product_master_add_ons = nil  
          productid = OrderLine.where(orderid: @order_master.id).pluck(:product_master_id)
          if ProductMasterAddOn.where(product_master_id: productid).present? 
          @product_master_add_ons = ProductMasterAddOn.where(product_master_id: productid)
          end
    end
  def update_customer_order_list
      creditcardno =  nil
      expmonth = nil
      expyear = nil
      name_on_card = nil
      cardname = nil
      
      order_id = @order_master.id

      t = Time.zone.now
          nowhour = t.strftime('%H').to_i
          #=> returns a 0-padded string of the hour, like "07"
          nowminute = t.strftime('%M').to_i


      if @order_master.orderpaymentmode_id == 10000
         customer_credit_card = CustomerCreditCard.where(customer_id: @order_master.customer_id).last

        creditcardno =  customer_credit_card.card_no.truncate(20)
        expmonth = customer_credit_card.expiry_mon.truncate(20)
        expyear = customer_credit_card.expiry_yr_string.truncate(20)
        cardtype = CreditCard.find_type(creditcardno).truncate(20)
      end

      if @order_master.external_order_no.nil?
         customer_order_list =  CustomerOrderList.create(orderdate: Time.zone.now,
          title: @order_master.customer.salute.truncate(5).upcase, 
          fname: @order_master.customer.first_name.truncate(30).upcase, 
          lname: @order_master.customer.last_name.truncate(30).upcase, 
          add1: @order_master.customer_address.address1.truncate(30).upcase, 
          add2: @order_master.customer_address.address2.truncate(30).upcase, 
          add3: (@order_master.customer_address.address3.truncate(30).upcase if @order_master.customer_address.address3.present?), 
          landmark: @order_master.customer_address.landmark.truncate(50).upcase, 
          city: @order_master.customer_address.city.truncate(30).upcase, 
          mstate: @order_master.customer_address.state.truncate(50).upcase, 
          state: @order_master.customer_address.st.truncate(5).upcase, 
          pincode: @order_master.customer_address.pincode, 
          mstate: @order_master.customer_address.state.truncate(50).upcase, 
          tel1: @order_master.customer.mobile.truncate(20).upcase, 
          tel2: (@order_master.customer_address.telephone1.truncate(20).upcase if @order_master.customer_address.telephone1.present?),
          fax: (@order_master.customer_address.fax.truncate(20).upcase if @order_master.customer_address.fax.present?), 
          email: (@order_master.customer.emailid.truncate(20).upcase if @order_master.customer.emailid.present?), 
          ccnumber:  creditcardno, 
          expmonth:  expmonth, 
          expyear:  expyear, 
          cardtype: cardtype,
          ipadd: (@order_master.userip.truncate(50) if @order_master.userip.present?), 
          dnis: @order_master.calledno,
          channel: @order_master.medium.name.truncate(50).upcase, 
          carddisc: @order_master.creditcardcharges, 
          chqdisc: @order_master.creditcardcharges,
          totalamt: @order_master.subtotal + @order_master.shipping + @order_master.codcharges + @order_master.servicetax + @order_master.maharastracodextra ,
          trandate: Time.zone.now,
          username: @order_master.employee.name.truncate(50).upcase,
          oper_no: @order_master.employeecode,
          dt_hour: nowhour,
          dt_min: nowminute,
          uae_status: @order_master.customer.gender.truncate(50).upcase)
          
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
          # if orderline10.exists?
          #   customer_order_list.update(prod10: orderline10.first.product_variant.extproductcode, qty10: orderline10.first.pieces)
          # end
          if @order_master.customer_address.st.upcase == "MAH"
             customer_order_list.update(prod10: 2.5, qty10: 1)
          end
          #- Integer update with customer order id
          @order_master.update(external_order_no: customer_order_list.id.to_s, order_status_master_id: 10003) 

          return customer_order_list.ordernum
          external_order_no - string update with customer order id
            else
              customer_order_lists = CustomerOrderList.where(ordernum: order_master.external_order_no.to_i)
          customer_order_list = customer_order_lists.first
          customer_order_list.update(ordernum: order_id, orderdate: Time.zone.now,
          title: @order_master.customer.salute.truncate(5).upcase, 
          fname: @order_master.customer.first_name.truncate(30).upcase,
          lname: @order_master.customer.last_name.truncate(30).upcase,  
          add1: @order_master.customer_address.address1.truncate(30).upcase, 
          add2: @order_master.customer_address.address2.truncate(30).upcase, 
          add3: (@order_master.customer_address.address3.truncate(30).upcase if @order_master.customer_address.address3.present?), 
          landmark: @order_master.customer_address.landmark.truncate(50).upcase, 
          city: @order_master.customer_address.city.truncate(30).upcase, 
          state: @order_master.customer_address.state.truncate(5).upcase, 
          pincode: @order_master.customer_address.pincode, 
          mstate: @order_master.customer_address.state.truncate(50).upcase, 
          tel1: @order_master.customer.mobile.truncate(20).upcase, 
          tel2: (@order_master.customer_address.telephone1.truncate(20).upcase if @order_master.customer_address.telephone1.present?),
          fax: (@order_master.customer_address.fax.truncate(20).upcase if @order_master.customer_address.fax.present?), 
          email: (@order_master.customer.emailid.truncate(20).upcase if @order_master.customer.emailid.present?), 
          ccnumber:  creditcardno, 
          expmonth:  expmonth, 
          expyear:  expyear, 
          cardtype: cardtype,
          ipadd: (@order_master.userip.truncate(50).upcase if @order_master.userip.present?), 
          dnis: @order_master.calledno,
          channel: @order_master.medium.name.truncate(50).upcase, 
          carddisc: @order_master.creditcardcharges, 
          chqdisc: @order_master.creditcardcharges,
         totalamt: @order_master.subtotal + @order_master.shipping + @order_master.codcharges + @order_master.servicetax + @order_master.maharastracodextra ,
          trandate: Time.zone.now,
          username: @order_master.employee.name.truncate(50).upcase,
          oper_no: @order_master.employeecode,
          dt_hour: nowhour,
          dt_min: nowminute,
          uae_status: @order_master.customer.gender.truncate(50).upcase)     

          
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
          # if orderline10.exists?
          #   customer_order_list.update(prod10: orderline10.first.product_variant.extproductcode, qty10: orderline10.first.pieces)
          # end
          if @order_master.customer_address.st.upcase == "MAH"
             customer_order_list.update(prod10: 2.5, qty10: 1)
          end

          #process only that order which is not processed
       
           if @order_master.order_status_master_id < 10003
            @order_master.update( order_status_master_id:10003 ) 
          end    

          return customer_order_list.ordernum

            end


  end

  def interactions(refcatid)
    customer_address
     @intearaction_master = InteractionMaster.create(createdon: Time.now, 
        interaction_status_id:10000,
            customer_id: @order_master.customer_id, 
            callednumber: @order_master.calledno,
            interaction_category_id:refcatid, 
            orderid: @order_master.id, 
            interaction_priority_id:10000,
            campaign_playlist_id: @order_master.campaign_playlist_id, 
            state: @customer_address.state, resolveby: 2.days.from_now)

          if order_master_params[:comments].present?
            @interaction_transcripts = @intearaction_master.interaction_transcript.create(description:order_master_params[:comments], interactionuserid:10000, callednumber:calledno)
          end
    
    end

  def check_order
    if params[:order_id].present?
     orderid = params[:order_id] 

     order_master =  OrderMaster.find(orderid)
     statusno = order_master.order_status_master_id
      ondate = order_master.updated_at.to_s
      if order_master.order_status_master_id >= 10003
         flash[:error] = "This order no #{orderid} is already processed at #{ondate}" 
        redirect_to summary_path(:order_id => @order_master.id)
       end
    end
  end
end
