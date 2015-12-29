class CustomerorderController < ApplicationController

before_action { protect_controllers(20) }
#before_action :productlist, only: [:products, :offline, :add_products]
before_action :order_line_params, only: [ :add_products]
before_action :set_order, except: [:summary]
before_action :new_call
before_action :check_order, except: [:summary]
before_action :allowprocessing, except: [:summary, :new_dealer, :dealers]
before_action :customer_address, only: [ :upsell, :show_offers, :payment, :channel, :review]
before_action :customer, only: [ :upsell, :show_offers, :payment, :channel, :review]

  respond_to :html

#first Step is where the customer number and called no are shown together
#first Step is where the customer number and called no are shown together
def newcall
    new_call
    #if order is not null then create orderline with order id
    @order_line = OrderLine.new()
    todaydate = (330.minutes).from_now.to_date
    @allowtoadd = false
    @all_valid_promos = Promotion.where("TRUNC(start_date) <= ? AND TRUNC(end_date) >= ?", todaydate, todaydate)

    if @order_id.present?
        @order_line.orderid = @order_id
        specific_addon_product_lists
      #update_page_trail(page_name)
      update_page_trail("neworder / add products")
    end

    #promos
    @newproductlist = ProductList.take(0)

 #@newproductlist = productlist.map{|a| [a.name, a.id]}
  respond_with(@order_master, @order_lines, @order_line)
end

def update_product_list
    #http://pullmonkey.com/2012/08/11/dynamic-select-boxes-ruby-on-rails-3/
     #if media_tapes.present?
    @searchvalue = params[:searchvalue]
     @searchvalue =  @searchvalue.upcase
    # map to name and id for use in our options_for_select
    #product_masters = ProductMaster.where("productactivecodeid = ?", 10000).where("name like ? OR extproductcode like ? or description like ?", "#{@searchvalue}%", "#{@searchvalue}%", "#{@searchvalue}%").pluck("id")
    #product_variants = ProductVariant.where("activeid = ? and product_sell_type_id = ?", 10000, 10000).where(productmasterid: product_masters).where("name like ? OR extproductcode like ? or description like ?", "#{@searchvalue}%", "#{@searchvalue}%", "#{@searchvalue}%").pluck("id")
    #@productlist = ProductList.where('active_status_id = ?',  10000).where(product_variant_id: product_variants).joins(:product_variant).order("product_variants.name")
     product_variants = ProductVariant.where("activeid = ? and product_sell_type_id = ?", 10000, 10000).pluck("id")
    #product_list = ProductList.where(active_status_id: 10000).where("productlist.name like ? ", "#{@searchvalue}%").joins(:product_variant).order("product_variants.name")
    product_list = ProductList.where(active_status_id: 10000)
    .where(:product_variant_id => product_variants)
    .where("name like ? ", "#{@searchvalue}%")
    .order("name")

      found  = product_list.count
      @newproductlist = product_list.map{|s| [s.name, s.id]}


    #end
end


def products
    new_call


    #if order is not null then create orderline with order id
    @order_line = OrderLine.new()

    if @order_id.present?
        @order_line.orderid = @order_id
        specific_addon_product_lists

    end
    #update_page_trail(page_name)
    update_page_trail("neworder / add products (old page)")

  respond_with(@order_master, @order_lines, @order_line)
end

def offline
    #if order is not null then create orderline with order id
    employee = Employee.where(employeecode: current_user.employee_code)
    @user_file_name =  employee.last.mobile || "Not Set" << ".cli"

     #update_page_trail(page_name)
    update_page_trail("offline order")
end

def uploadcall
    userfile = params
     uploaded_io = params[:userfile]

            File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
    file.write(uploaded_io.read)
                    end
      file = File.join(Rails.root,  'public', 'uploads', uploaded_io.original_filename)
      #File.read(file)
      @filename = uploaded_io.original_filename
       @filedata = File.read(file)

      @na, @ext, @cli, @dnis = @filedata.split('|')
        # File.open(file, "r").each_line do |line|


        # # name: "Angela"    job: "Writer"    ...
        # data = line.split(/\t/)
        # @name, @job = data.map{|d| d.split("|")[1] }.flatten
      #end
      @order_id = neworder(10040, @cli.strip, @dnis.strip)

      redirect_to neworder_path(:order_id => @order_id)
end

def add_products
   #post

     new_call
    orderid = 0
         #check if order id present else create new order id using this process
    #check if order created else create new
    if params[:order_id].present?
       @order_id =  order_line_params[:orderid]
     else
      @cli = params[:mobile]
      @dnis = params[:calledno]
      @order_id = neworder(10000, @cli, @dnis)
      order_line_params[:orderid] = @order_id

    end
    #orderid = @order_id
    #flash[:notice] = "Order id is created #{orderid} called from numer #{@mobile} to number #{@calledno}"
    #flash[:error] = @order_master.errors.full_messages.join("<br/>")
    if order_line_params[:product_list_id].present?

      addproducts_to_order(@order_id, order_line_params[:product_list_id], order_line_params[:pieces])
    else
         flash[:error] = "You have not selected the correct product try to select from the list"
    end

    redirect_to neworder_path(:order_id => @order_id)

    end

  def add_basic_upsell
        #post
     if params[:product_list_id].present?
      product_list_id = params[:product_list_id]
      order_id = params[:order_id]
      #code to replace product if it meant to be replaced
      #check product master add on for column replace_by_product_id
      #get the product master id for the product

      product_list = ProductList.find(product_list_id) #.pluck('product_variant_id')
      product_variant = ProductVariant.find(product_list.product_variant_id) #PRODUCTMASTERID
      if ProductMasterAddOn.where('PRODUCT_MASTER_ID = ? and replace_by_product_id IS NOT NULL', product_variant.productmasterid).present?
        #destroy the line
       product_add_on = ProductMasterAddOn.where('PRODUCT_MASTER_ID = ? and replace_by_product_id IS NOT NULL', product_variant.productmasterid)

       product_list_id = product_add_on.last.replace_by_product_id

    product_variants = ProductVariant.where("activeid = ?", 10000).where(productmasterid: product_variant.productmasterid).pluck("id")
    seachforproductlists = ProductList.where('active_status_id = ?',  10000).where(product_variant_id: product_variants).pluck(:id)


        order_line = OrderLine.where(orderid:order_id).where(product_list_id: seachforproductlists).first

 #flash[:error] = "order line check for id: #{product_variant.productmasterid} and #{order_id}"

        if order_line.present?
            #flash[:error] = "order line check for #{order_line.id}"

           order_line.destroy
        end


      end

      addproducts_to_order(order_id,product_list_id, 1)
    else
      flash[:error] = "You have not selected the correct product try to select from the list"
    end
    redirect_to neworder_path(:order_id => @order_id)

  end

  def address
      @states = State.all.order("name")

      if @order_master.customer_id.present?
        @customer = Customer.find(@order_master.customer_id)
        flash[:notice] = "Existing Customer found #{@customer.id}"
        @customer_id = @customer.id
      elsif Customer.where(mobile: @order_master.mobile).present?
        @customer = Customer.where(mobile: @order_master.mobile).last
        flash[:notice] = "Earlier called Customer found #{@customer.id}"
        @customer_id = @customer.id
      else
        @customer = Customer.new(mobile: @order_master.mobile)
        flash[:notice] = "Add Customer Name"
      end

      if @order_master.customer_address_id.present?
        @customer_address = CustomerAddress.find(@order_master.customer_address_id)
        flash[:notice] = " An address has been added for the customer"
      elsif CustomerAddress.where(telephone1: @order_master.mobile).present?
        @customer_address = CustomerAddress.where(telephone1: @order_master.mobile).last
        flash[:notice] = " Existing address is available for the number #{@order_master.mobile}"
      else
        @customer_address = CustomerAddress.new(telephone1: @order_master.mobile)
         flash[:notice] = "Add Customer Address."
      end

      #flash[:notice] = "#{notice}"

      #respond_with(@order_master, @order_lines, @customer_address, @customer)
      if @customer_address.pincode.present?
        @india_pincode_lists = IndiaPincodeList.where("UPPER(pincode) = ?", @customer_address.pincode).limit(100)
      else
        @india_pincode_lists = IndiaPincodeList.limit(0)
      end

      #update_page_trail(page_name)
      update_page_trail("address")
  end

   def show_pincode_list
    #http://pullmonkey.com/2012/08/11/dynamic-select-boxes-ruby-on-rails-3/
     #if media_tapes.present?
    @searchvalue = params[:searchvalue]
    @searchvalue =  @searchvalue.upcase

   # @india_pincode_lists = IndiaPincodeList.where("UPPER(divisionname) like ? OR UPPER(pincode) like ? OR UPPER(districtname) like ? OR UPPER(regionname) like ? OR UPPER(taluk) like ? OR UPPER(circlename) like ? OR UPPER(statename) like ?", "#{@searchvalue}%", "#{@searchvalue}%", "#{@searchvalue}%", "#{@searchvalue}%", "#{@searchvalue}%", "#{@searchvalue}%", "#{@searchvalue}%")
    @india_pincode_lists = IndiaPincodeList.where("UPPER(divisionname) like ? OR UPPER(pincode) like ? OR UPPER(districtname) like ? OR UPPER(regionname) like ? OR UPPER(taluk) like ? OR UPPER(circlename) like ?", "#{@searchvalue}%", "#{@searchvalue}%", "#{@searchvalue}%", "#{@searchvalue}%", "#{@searchvalue}%", "#{@searchvalue}%").limit(250)

    @india_pincode_lists = @india_pincode_lists.order(:pincode)
     @india_pincode_lists = @india_pincode_lists.map{|s| [s.details, s.pincode]}

    #render json: @india_pincode_lists
  end

  def add_address
          @states = State.all.order("name")

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
    #:city, :pincode update
    @order_master.update(city: @customer_address.city, pincode: @customer_address.pincode)

    @order_master.update(customer_address_id: @customer_address.id)

    flash[:success] = "Successfully Added Customer Address."

    redirect_to upsell_path(:order_id => @order_id)
  end

  def upsell
   # product_masters = ProductMaster.where("productactivecodeid = ?", 10000).pluck("id")
    #product_variants = ProductVariant.where("activeid = ? and product_sell_type_id = ?", 10000, 10001).where(productmasterid: product_masters).pluck("id")
    #@generalproductaddonlists = ProductList.where('active_status_id = ?',  10000).where(product_variant_id: product_variants).joins(:product_variant).order("product_variants.name")

    @generalproductaddonlists = ProductList.where('product_lists.active_status_id = ?',  10000).joins(:product_variant).where("product_variants.activeid = ? and product_variants.product_sell_type_id = ?", 10000, 10001).order("product_variants.name")

    #.paginate(:page => params[:page], :per_page => 1)
    #<%= will_paginate @generalproductaddonlists, :container => true %>
     #update_page_trail(page_name)

      update_page_trail("upsell")
  end

  def add_upsell
    #this is common upsell
     if params[:product_list_id].present?
      product_list_id = params[:product_list_id]

      addproducts_to_order(params[:order_id], params[:product_list_id], params[:pieces])
    else
      flash[:error] = "You have not selected the correct product try to select from the list"
    end
    redirect_to upsell_path(:order_id => @order_id)

  end

  def show_offers

    @allowtoadd = true
    todaydate = (330.minutes).from_now.to_date
    @all_valid_promos = Promotion.where("TRUNC(start_date) <= ? AND TRUNC(end_date) >= ? AND ACTIVE = ?", todaydate, todaydate, 1)
   if @all_valid_promos.blank?
     flash[:success] = "No offers found taking to payment page"
     redirect_to payment_path(:order_id => @order_id)
   end

   #update_page_trail(page_name)
    update_page_trail("offers")
     if @all_valid_promos.present?
       add_offer(@all_valid_promos.first.id)
     end

    #flash[:success] = "You can now choose the offer, you have #{@all_valid_promos.count()} options to add to the order"

  end

  def add_offer(promotion_id)
    #add promo to order
   # promotion_id = params[:promotion_id]
    @valid_promo = Promotion.find(promotion_id)
    #check if promo id already added
    flash[:success] = "You have added the offer #{@valid_promo.name} to the order"
    if @order_master.promotion_id.to_i != promotion_id.to_i
      #existingnotes = @order_master.notes || " " if @order_master.notes.present?
      existingnotes = " Promo added #{@valid_promo.name}"
      @order_master.update(notes: existingnotes, promotion_id: promotion_id)

      flash[:success] = "You have added the offer #{@valid_promo.name} to the order"

      if params[:free_product_list_id].present?
        #check if order found in the order lines
        if OrderLine.where(product_list_id: params[:free_product_list_id]).blank?
          addproducts_to_order(@order_id, params[:free_product_list_id], 1)
          flash[:success] = "You have added the offer #{@valid_promo.name} to the order"
        else
          flash[:success] = "You have previously added the offer #{@valid_promo.name} to the order"
        end
      end
    else
      flash[:success] = "You have already added the offer #{@valid_promo.name} to the order"
    end

     redirect_to payment_path(:order_id => @order_id)
  end

  def payment

    if @order_master.customer_address_id.blank?
      flash[:error] = "No Address found you need to add / save address before you process payment " << Time.now.to_s
        return redirect_to address_path(:order_id => @order_master.id)
    end

    if @order_master.customer_id.present?
        @customer_credit_card_o = CustomerCreditCard.where(customer_id: @order_master.customer_id).last
    end

    @customer_credit_card = CustomerCreditCard.new(customer_id:  @order_master.customer_id)

    @cashondeliveryid = 10001
    orderpaymentmode_1 = Orderpaymentmode.find(@cashondeliveryid).charges

    #@atomccpaymentmodeid = 10060

    cod_amount_i = @order_master.subtotal + @order_master.shipping + @order_master.codcharges + @order_master.servicetax + @order_master.maharastracodextra

    @atomccpaymentmodeid = 10060
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
    elsif @order_master.orderpaymentmode_id == 10060 #paid over Atom CC
     @paidover = "Already Paid over Credit / Debit Card of Atom"

      @cod_amount = "Rs #{cod_amount_i}"
      @cc_amount = "Pay Rs #{cc_amount_i}"

   elsif @order_master.orderpaymentmode_id == 10001 #paid over COD
     @paidover = "Already Paid over Cash on Delivery"

      @cod_amount = "Rs #{cod_amount_i}"
      @cc_amount = "Pay Rs #{cc_amount_i}"
     end
  end


    #update_page_trail(page_name)
      update_page_trail("payment")
    #respond_with(@order_master, @order_lines,  @customer_credit_card_o, @customer_credit_card)
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
      @medialist =  Medium.where(active:1).where('dnis = ?', @order_master.calledno).order("updated_at DESC")

        if @medialist.count == 1   #&& @all_calllist.empty?
          @order_master.update(media_id: @medialist.first.id)
          medianame = @medialist.first.name

          add_product_to_campaign(@medialist.first.id)
          flash[:success] = " Media #{medianame} added "
          return redirect_to review_path(:order_id => @order_master.id)
        end

        if @order_master.customer_address.state.present?
          @medialist = @medialist.where(state: @order_master.customer_address.state)

           if @medialist.present?
            @order_master.update(media_id: @medialist.first.id)
            medianame = @medialist.first.name
            add_product_to_campaign(@medialist.first.id)

            flash[:success] = " Media #{medianame} with state #{@order_master.customer_address.state.upcase} added "
            return redirect_to review_path(:order_id => @order_master.id)
          else
            #update_page_trail(page_name)
            update_page_trail("channel")
            @medialist =  Medium.where(active:1).where('dnis = ?', @order_master.calledno).order("updated_at DESC")
          end
        end

        # if Medium.where(active:1).where('dnis = ? and state = ?', @order_master.calledno, @order_master.customer_address.state.upcase).present?
        #   @newmedialist = Medium.where(active: 1).where('dnis = ? and state = ?', @order_master.calledno, @order_master.customer_address.state.upcase)
        #   @order_master.update(media_id: @newmedialist.first.id)
        #   medianame = @newmedialist.first.name
        # end

    #respond_with(@order_master, @order_lines, @customer, @customer_address)
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
          flash[:error] = "The Order value #{@order_master.total} is too low to be processed"
     end
     if @order_master.customer_address_id.blank?
          @show_process = 1
          flash[:error] = "Customer Address is missing "
      end
      if @order_master.customer_id.blank?
         flash[:error] = "Customer Name and details are missing "
      end
      #check for payment mode
      if @order_master.orderpaymentmode_id.blank?
        @show_process = 1
        flash[:error] = " Payment details are missing!"
      end

      if @order_master.media_id.blank?
        @show_process = 1
        flash[:error] = ' Media is missing '
      end

       if @order_lines_regular.blank?
        @show_process = 1
        flash[:error] = 'You have not added any regular products, this order cannot be processed!'
       end

       if @order_lines_regular.count > 1
       # @order_lines_regular = @order_lines_regular.offset(1)
        @review_message = "There are #{@order_lines_regular.count} products, this order would be split into #{@order_lines_regular.count} orders."
        flash[:error] = "This order would be split into #{@order_lines_regular.count} orders"
       end


      #update_page_trail(page_name)
      update_page_trail("review")
    #respond_with(@order_master, @order_lines, @customer, @customer_address)
  end

  def process_order
        #this is post
        order_number = []
        msg = nil
        order_total = 0
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
      order_total = @order_master.grand_total

      if @order_lines_regular.blank?
        @show_process = 1
        flash[:error] = 'You have not added any regular products, this order cannot be processed!'
         redirect_to orderreview_path(:order_id => @order_master.id)
       end

       if @order_lines_regular.count > 1
        notices = []
        notice = ""

        #@review_message = "There are #{@order_lines_regular.count} products, this order would be split into #{@order_lines_regular.count} orders."
          # use this to duplicate_order
          # move the relevant order line to new order
        new_reg_order_lines =  @order_lines_regular.offset(1)

        new_reg_order_lines.each do |order|
            #create a new order
            new_order =  duplicate_order(@order_master.id)

            #switch the order line to new order master
            #first the regular product
            order.update(orderid: new_order)
            if @order_lines_basic.count > 0
              list_of_upsells = ProductMasterAddOn.where(product_master_id: order.product_master_id)
              .pluck(:product_list_id)
              sold_upsells = @order_lines_basic.where(product_list_id: list_of_upsells)
                if sold_upsells.count > 0
                  sold_upsell = sold_upsells.first
                   #notice +=  "Found a matching product from list of upsell #{sold_upsell.description}"
                  sold_upsell.update(orderid: new_order)
                end #checked if basic upsell is found to be matching
            end #check if upsell if found

            orderprocessed = update_customer_order_list(new_order)
              order_split = OrderMaster.find(new_order)

           order_number << order_split.external_order_no + " for Rs " + order_split.grand_total.to_i.to_s


        end #loop through the order lines Regular
          #save orderline
            orderline_last = OrderLine.where(orderid: @order_master.id)
            orderline_last.each do |ordl|
              ordl.save
            end

          orderprocessed = update_customer_order_list(@order_master.id)

           order_final = OrderMaster.find(@order_master.id)

          notice += "This order has been be split in #{@order_lines_regular.count} orders"

          order_number << order_final.external_order_no + " for Rs " + order_final.grand_total.to_i.to_s
            payment_mode_id = order_final.orderpaymentmode_id
            payment_mode_id = payment_mode_id.to_i
            case payment_mode_id
            when 10000 #paid over CC
              msg = ". "
            when 10001
              msg = ". Please pay cash on delivery "
            when 10060 #paid over ATOM CC
              msg = ". "
            end


         flash[:notice] = notice
        else #IF ONLY one regular product found

          # after this is done complete the ordering
          orderprocessed = update_customer_order_list(@order_master.id)
           order_master = OrderMaster.find(@order_master.id)
          order_number << order_master.external_order_no  + " for Rs " + order_master.grand_total.to_i.to_s
            payment_mode_id = order_master.orderpaymentmode_id
            payment_mode_id = payment_mode_id.to_i
            case payment_mode_id
            when 10000 #paid over CC
              msg = ". "
            when 10001
              msg = ". Please pay cash on delivery "
            when 10060 #paid over ATOM CC
              msg = ". "
            end

       end

# COD ORDER FORMAT:
# THANKS FOR ORDER NO--------- FOR Rs.------------, PRODUCTS WILL REACH YOU IN 7-10 DAYS. PLEASE PAY CASH ON DELIVERY. FOR ANY ORDER RELATED QUERIES CONTACT OUR CUSTOMER CARE ON 9223100730 9.30AM TO 06.30PM. TELEBRANDS.

# CREDIT CARD/CC ON ATOM ORDER FORMAT:
# THANKS FOR ORDER NO---------- FOR Rs.-----------, PRODUCTS WILL REACH YOU IN 7-10DAYS. FOR ANY ORDER RELATED QUERIES CONTACT OUR CUSTOMER CARE ON 9223100730 9.30AM TO 06.30PM. TELEBRANDS
#Thks for order no <Variable1> For Rs. <Variable2> Products will reach in 7-10 days Pls pay cash on delivery Queries Call 9223100730 HBN / TELEBRANDS
#Thks for order no <Variable1> For Rs. <Variable2> Products will reach in 7-10 days, any queries Call 9223100730 HBN / TELEBRANDS

          message = "Thanks for order no #{order_number.join(",")}, products will reach you in 7-10 days#{msg}any queries Call 9223100730 HBN / TELEBRANDS"

          message = message[0..159]
          @sms_message = MessageOnOrder.create(customer_id: @order_master.customer_id,
            message_status_id: 10000, message_type_id: 10000,
            mobile_no: @order_master.customer.mobile,
            alt_mobile_no: @order_master.customer.alt_mobile,
            message: message)

          flash[:success] = "SMS: #{message}"

    redirect_to summary_path(:order_id => @order_master.id)


  end
  def summary
    if params.has_key?(:order_id)
      order_id = params[:order_id]
    #   customer
    #   @cust_details_id = @order_master.external_order_no
      @ordernos = []
      order_number = []
       msg = nil
    # #mix the orders to add all the related orders
       @order_master_lists = OrderMaster.where('id = ? OR original_order_id = ?', order_id, order_id)
      @show_details = 1
     time_as_now = Time.zone.now - 1.hour
      if @order_master_lists.where("updated_at > time_as_now")
         @show_details = 0
      end
      @empcode = current_user.employee_code
      cur_employee_id = Employee.where(employeecode: @empcode).first.id
      if @order_master_lists.where("employee_id <> ?", cur_employee_id)
         update_page_trail("unauthorised view of order attempted by user #{@empcode}")
          @show_details = 0
      end

       if @order_master_lists.first.external_order_no.blank?
          @order_message = "The orders are not processed"
          @order_processed_next_steps = "Please go back and process the order"
          flash[:error] = "The order is not processed"
       else
          @order_master_lists.each do |ord|
            @ordernos << ord.external_order_no << " "

            # order_number << ord.external_order_no + " for Rs " + ord.total.to_i.to_s
            # payment_mode_id = ord.orderpaymentmode_id
            # payment_mode_id = payment_mode_id.to_i
            # case payment_mode_id
            # when 10000 #paid over CC
            #   msg = " Thanks for payment "
            # when 10001
            #   msg = " Please pay cash on delivery "
            # end

        end

          orderprocessed = update_customer_order_list(@order_master.id)

           # order_number << @order_master.external_order_no + " for Rs " + @order_master.grand_total.to_i.to_s
           #  payment_mode_id = @order_master.orderpaymentmode_id
           #  payment_mode_id = payment_mode_id.to_i
           #  case payment_mode_id
           #  when 10000 #paid over CC
           #    msg = " Thanks for payment "
           #  when 10001
           #    msg = " Please pay cash on delivery "
           #  end

          @order_message = "Awesome, #{@order_master_lists.count}  order successfully processed"
          @order_processed_next_steps = "Please close this window and wait for next call"

          # message = "Thanks for Order, #{order_number.join(",")}, products will reach you in 7-10 days. #{msg} Telebrands"
          # message = message[0..159]
          # flash[:success] = "SMS: #{message}"
          # message = "Thanks for Order, #{order_number.join(",")}, products will reach you in 7-10 days. #{msg} Telebrands"
          # message = message[0..159]
          # @sms_message = MessageOnOrder.create(customer_id: @order_master.customer_id,
          #   message_status_id: 10000, message_type_id: 10000,
          #   mobile_no: @order_master.customer.mobile,
          #   alt_mobile_no: @order_master.customer.alt_mobile,
          #   message: message)

       end

     end
     #update_page_trail(page_name)
      update_page_trail("summary")
  end

  #other menus
  def new_dealer
    @customer = Customer.new(mobile: @mobile)
    @interaction_master = InteractionMaster.all
    @interactioncategorylist =  InteractionCategory.where("sortorder >= 10")


    @interactionprioritylist =  InteractionPriority.all
    respond_with(@interaction_master, @customer)
    #update_page_trail(page_name)
    update_page_trail("new dealer")
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
      #update_page_trail(page_name)
      update_page_trail("existing dealers")
      #respond_with(@cities, @address_dealer)
  end



  private
  def update_page_trail(page_name)
    url = request.original_url
    @empcode = current_user.employee_code
    employee_id = Employee.where(employeecode: @empcode).first.id
    #.permit(:name, :order_id, :page_id, :url, :employee_id, :duration_secs)
    PageTrail.create(name: page_name, order_id: @order_id, url: url, employee_id: employee_id)

  end
    def allowprocessing

      if !params[:order_id].present?
        return @allow_processing = 1
      end
      if @order_master.total < 100
          return @allow_processing =  1
      end
      if @order_master.customer_address_id.blank?
       return @allow_processing = 1
      end
      if @order_master.external_order_no.blank?
       return @allow_processing = 1
      end
       if @order_master.customer_id.blank?
       return @allow_processing = 1
      end
      if @order_master.orderpaymentmode_id.blank?
       return @allow_processing =  1
      end

      if @order_master.media_id.blank?
        return @allow_processing = 1
      end

      return @allow_processing = 0

    end
    def add_product_to_campaign(mediumid)
      updates = "Trying to update order master with show for media #{mediumid}"
        product_variant_id = OrderLine.where(orderid: @order_master.id)
        .order("id").pluck(:productvariant_id).first

         # product_variant_id = productvariants
          t = (330.minutes).from_now #Time.zone.now + 330.minutes
          nowhour = t.strftime('%H').to_i
          nowminute = t.strftime('%M').to_i
          todaydate = (330.minutes).from_now.to_date
          #maxuptodate = (2880.minutes).from_now.to_date
          max_go_back_date = (todaydate.to_time - 48.hours).to_datetime
          @nowsecs = (nowhour * 60 * 60) + (nowminute * 60)
          # check if media is part of HBN group
          # check if media is part of HBN group, if yes, update the HBN group
          # campaign playlist id both ways
          # on order and agains the campaign playlis
          if Medium.where(id: mediumid).present?
             channelname = Medium.find(mediumid).name
          end

          if Medium.find(mediumid).media_group_id == 10000
            #HBN Master Media Id 11200
            #select the campaign from HBN Master Campaign List
            channel = "HBN Shows on #{channelname}"
            campaignlist =  Campaign.where(mediumid: 11200).where("TRUNC(startdate) <= ? AND TRUNC(startdate) >= ?", todaydate, max_go_back_date)
          else
            channel = "#{channelname} Private Channel Shows"
            campaignlist =  Campaign.where(mediumid: mediumid).where("TRUNC(startdate) <= ? AND TRUNC(startdate) >= ?", todaydate, max_go_back_date)
          end
          updates = "Updated at #{t} order for #{channel} without any specific show at Hour:#{nowhour}  Minutes:#{nowminute}"
          if campaignlist.present?
            campaign_playlist = CampaignPlaylist.where({campaignid: campaignlist})
            .where(list_status_id: 10000).where(productvariantid: product_variant_id)
            .where("(start_hr * 60 * 60) + (start_min * 60) <= ?", @nowsecs)
            .where("TRUNC(for_date) <= ?", todaydate)
            .order("for_date DESC, start_hr DESC, start_min DESC")
             updates = "Updated at #{t} order for #{channel} without any relevant show name at Hour:#{nowhour}  Minutes:#{nowminute}"
            if campaign_playlist.count > 0
              @order_master.update(campaign_playlist_id: campaign_playlist.first.id)
              updates = "Updated at #{t} order for #{channel} with show #{campaign_playlist.name} at Hour:#{nowhour}  Minutes:#{nowminute}"
            else
              #update for earlier date playlists

              #this is designed for the playlist to go back as as required to assign this order for
              # a particular date
              older_campaign_playlist = CampaignPlaylist.where("TRUNC(for_date) <= ? AND TRUNC(for_date) >= ?", todaydate, max_go_back_date)
              .where(list_status_id: 10000).where(productvariantid: product_variant_id)
              .order("for_date DESC, start_hr DESC, start_min DESC")
              if older_campaign_playlist.count > 0
                @order_master.update(campaign_playlist_id: older_campaign_playlist.first.id)
                updates = "Updated at #{t} order for #{channel} with show #{older_campaign_playlist.name} at Hour:#{nowhour}  Minutes:#{nowminute}"
              end
            end
          end
          total_notes = @order_master.notes + updates
          @order_master.update(notes: total_notes)
    end

    def new_call
      set_order
      @calledno = params[:calledno] #|| if params[:calledno].present?
      @mobile = params[:mobile] #|| if params[:mobile].present?
       @channellist =  Medium.where(active: 1).where('dnis = ?',  params[:calledno]).where('active = 1')
      if params[:order_id].present?
       @order_id = params[:order_id]
       @customer_id = @order_master.customer_id
       @calledno = @order_master.calledno
       @mobile = @order_master.mobile

        @channellist =  Medium.where(active: 1).where('dnis = ?', @order_master.calledno).where('active = 1')
      end

      @empcode = current_user.employee_code
      #@empid = current_user.id
      @empid = Employee.where(employeecode: @empcode).first.id

      #used to report call details
      @interactioncategorylist =  InteractionCategory.where("sortorder > 100")

      #used to dispose calls
      @interactiondisposelist =  InteractionCategory.where("sortorder < 100 and id <> 10101 and id <> 10102")
      #check if order is in Interaction Master with Category Id = 10100 => Attempt 1
    if (InteractionMaster.where(orderid: @order_id).where(interaction_category_id: 10100)).present?
      @interactiondisposelist =  InteractionCategory.where("sortorder < 100 and id <> 10100 and id <> 10102")
    end

    #check if order is in Interaction Master with Category Id = 10101 => Attempt 2
    if (InteractionMaster.where(orderid: @order_id).where(interaction_category_id: 10101)).present?
      @interactiondisposelist =  InteractionCategory.where("sortorder < 100 and id <> 10100 and id <> 10101")

    end

    #check if order is in Interaction Master with Category Id = 10102 => Attempt 3
    if (InteractionMaster.where(orderid: @order_id).where(interaction_category_id: 10101)).present?
       @interactiondisposelist =  InteractionCategory.where("sortorder < 100 and id <> 10100 and id <> 10101 and id <> 10102")

    end

      @interactionprioritylist =  InteractionPriority.all

    end


    def neworder(source, cli, dnis)

      @order_master = OrderMaster.create!(calledno: dnis, order_status_master_id: 10000,
        orderdate: Time.zone.now, pieces: 0,subtotal: 0, taxes: 0, codcharges: 0,
        shipping:0, total: 0, order_source_id: source.to_i, employeecode: @empcode,
        employee_id: @empid, userip: request.remote_ip, sessionid: session.id,
        order_for_id: 10000, mobile: cli, notes: " ", g_total: 0)

      return @order_master.id
    end

    def duplicate_order(old_order_id)
      @old_order_master = OrderMaster.find(old_order_id)
 #@order_master.update{city: @customer_address.city, pincode: @customer_address.pincode}

      @new_order_master = OrderMaster.create!(calledno: @old_order_master.calledno,
        order_status_master_id: 10000,
        orderdate: @old_order_master.orderdate,
        customer_id: @old_order_master.customer_id,
        customer_address_id: @old_order_master.customer_address_id,
        pieces: 0,subtotal: 0,
        taxes: 0, codcharges: 0, shipping:0,
        orderpaymentmode_id:  @old_order_master.orderpaymentmode_id,
        total: 0, order_source_id: @old_order_master.order_source_id,
        campaign_playlist_id: @old_order_master.campaign_playlist_id,
        media_id: @old_order_master.media_id,
        employeecode: @empcode, employee_id: @empid,
        userip: request.remote_ip, sessionid: session.id,
        order_for_id: 10000, mobile: @old_order_master.mobile,
        original_order_id: old_order_id,
        city: @old_order_master.city, pincode: @old_order_master.pincode,
        g_total: 0 ,
        notes: @old_order_master.notes + " Duplicated Order for #{old_order_id}")


      @old_order_master.update(original_order_id: old_order_id)

      return @new_order_master.id
    end

    def addproducts_to_order(order_id, product_list_id, pieces)
      exproductlist = ProductList.find(product_list_id)
      exproductvariant = ProductVariant.find(exproductlist.product_variant_id)
      @order_lines = OrderLine.where("product_list_id = ? AND orderid = ?",
      product_list_id, order_id)
      product_name = exproductlist.name

        if @order_lines.exists?
            pieces = @order_lines.first.pieces + pieces.to_i
            @order_lines.first.update(pieces: pieces,
             subtotal: exproductvariant.price * pieces,
                taxes: exproductvariant.taxes * pieces,
                codcharges: 0,
                shipping: exproductvariant.shipping * pieces,
               total: exproductvariant.total * pieces)

            flash[:success] = " #{pieces} Piece/s of #{product_name} successfully added "
          else
                pieces = pieces.to_i
                @order_line = OrderLine.create(orderid: @order_id,
                orderdate: Time.zone.now,
                employeecode: @empcode, employee_id: @empid,
                subtotal: exproductvariant.price * pieces,
                taxes: exproductvariant.taxes * pieces,
                codcharges: 0,
                shipping: exproductvariant.shipping * pieces,
                pieces:  pieces,
                total: exproductvariant.total * pieces,
                description: product_name,
                productvariant_id: exproductlist.product_variant_id,
                product_master_id: exproductvariant.productmasterid,
                product_list_id: product_list_id,
                orderlinestatusmaster_id: 10000)
            if @order_line.valid?
                flash[:success] = "#{product_name} successfully added "
            else
                flash[:error] = @order_line.errors.full_messages.join("<br/>")
            end
        end

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
        @order_id = params[:order_id]
          @order_master = OrderMaster.find(@order_id)
          @order_lines = OrderLine.where(orderid: @order_id)

           @order_lines_regular = OrderLine.where(orderid: @order_id)
            .joins(:product_variant)
            .where('PRODUCT_VARIANTS.product_sell_type_id = ?', 10000)

         @order_lines_basic = OrderLine.where(orderid: @order_id)
         .joins(:product_variant)
         .where('product_variants.product_sell_type_id = ?', 10040)

         @order_lines_common = OrderLine.where(orderid: @order_id)
         .joins(:product_variant)
         .where('product_variants.product_sell_type_id = ?', 10001)

         @order_lines_free = OrderLine.where(orderid: @order_id)
         .joins(:product_variant)
         .where('product_variants.product_sell_type_id = ?', 10060)

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
    #  @productlist = ProductList.where('active_status_id = ?',  10000).where(product_variant_id: product_variants).joins(:product_variant).order("product_variants.name")
      @productlist = ProductList.where('active_status_id = ?',  10000).joins(:product_variant).order("product_variants.name")
    end

    def specific_addon_product_lists
         @specificproductaddonlist = nil
         if @order_master.present?
          product_master_id = OrderLine.where(orderid: @order_master.id).pluck(:product_master_id)
          @specificproductaddonlist = ProductMasterAddOn.where(product_master_id: product_master_id).order('sort_order DESC')
         end
    end



  def update_customer_order_list(order_id)
      creditcardno =  nil
      expmonth = nil
      expyear = nil
      name_on_card = nil
      cardname = nil

      #order_id = @order_master.id
      pro_order_master = OrderMaster.find(order_id)

      gra_total = pro_order_master.subtotal + pro_order_master.shipping + pro_order_master.codcharges + pro_order_master.servicetax + pro_order_master.maharastracodextra + pro_order_master.creditcardcharges + pro_order_master.maharastraccextra

      pro_order_master.update(g_total: gra_total)

      t = Time.zone.now + 330.minutes
          nowhour = t.strftime('%H').to_i
          #=> returns a 0-padded string of the hour, like "07"
          nowminute = t.strftime('%M').to_i

       creditcardcharges = ''

      if pro_order_master.orderpaymentmode_id == 10000
        customer_credit_card = CustomerCreditCard.where(customer_id: pro_order_master.customer_id).last
        creditcardno =  customer_credit_card.card_no.truncate(20)
        expmonth = customer_credit_card.expiry_mon.truncate(2).rjust(2, '0')
        expyear = customer_credit_card.expiry_yr_string.truncate(4).rjust(4, '0')[-2..-1]
        cardtype = CreditCard.find_type(creditcardno).truncate(20)
        creditcardcharges = "Y"
      end
      if pro_order_master.orderpaymentmode_id == 10060
        creditcardno =  "4111111111111111"
        expmonth = (Time.zone.now + 330.minutes).month
        expyear = (Time.zone.now + 330.minutes).year
        cardtype = "Atom CC"
        creditcardcharges = "Y"
      end

      if pro_order_master.external_order_no.nil?
         qty1 = 0
         qty2 = 0
         qty3 = 0
         qty4 = 0
         qty5 = 0
         qty6 = 0
         qty7 = 0
         qty8 = 0
         qty9 = 0
         qty10 = 0
         prod1 = ""
         prod2 = ""
         prod3 = ""
         prod4 = ""
         prod5 = ""
         prod6 = ""
         prod7 = ""
         prod8 = ""
         prod9 = ""
         prod10 = ""

         orderline1 = OrderLine.where("orderid = ?", order_id).order("id")
          if orderline1.present?
            qty1 = orderline1.first.pieces.to_i
            prod1 = orderline1.first.product_list.extproductcode[0..9].upcase
            #customer_order_list.update(qty1: qty1, prod1: prod1)
          end

          orderline2 = OrderLine.where("orderid = ?", order_id).order("id").offset(1)
          if orderline2.present?
            qty2 = orderline2.first.pieces.to_i
            prod2 = orderline2.first.product_list.extproductcode[0..9].upcase
            #customer_order_list.update(prod2: prod2, qty2: qty2)
          end
          orderline3 = OrderLine.where("orderid = ?", order_id).order("id").offset(2)
          if orderline3.present?
            qty3 = orderline3.first.pieces.to_i
            prod3 = orderline3.first.product_list.extproductcode[0..9].upcase
            #customer_order_list.update(prod3: orderline3.first.product_list.extproductcode.truncate(10).upcase, qty3: orderline3.first.pieces.to_i)
          end
          orderline4 = OrderLine.where("orderid = ?", order_id).order("id").offset(3)
          if orderline4.present?
            qty4 = orderline4.first.pieces.to_i
            prod4 = orderline4.first.product_list.extproductcode[0..9].upcase
            #customer_order_list.update(prod4: orderline4.first.product_list.extproductcode.truncate(10).upcase, qty4: orderline4.first.pieces.to_i)
          end
          orderline5 = OrderLine.where("orderid = ?", order_id).offset(4)
          if orderline5.present?
            qty5 = orderline5.first.pieces.to_i
            prod5 = orderline5.first.product_list.extproductcode[0..9].upcase
            #customer_order_list.update(prod5: orderline5.first.product_list.extproductcode.truncate(10).upcase, qty5: orderline5.first.pieces.to_i)
          end
          orderline6 = OrderLine.where("orderid = ?", order_id).offset(5)
          if orderline6.present?
            qty6 = orderline6.first.pieces.to_i
            prod6 = orderline6.first.product_list.extproductcode[0..9].upcase
            #customer_order_list.update(prod6: orderline6.first.product_list.extproductcode.truncate(10).upcase, qty6: orderline6.first.pieces.to_i)
          end
          orderline7 = OrderLine.where("orderid = ?", order_id).offset(6)
          if orderline7.present?
            qty7 = orderline7.first.pieces.to_i
            prod7 = orderline7.first.product_list.extproductcode[0..9].upcase
            #customer_order_list.update(prod7: orderline7.first.product_list.extproductcode.truncate(10).upcase, qty7: orderline7.first.pieces.to_i)
          end
          orderline8 = OrderLine.where("orderid = ?", order_id).offset(7)
          if orderline8.present?
            qty8 = orderline8.first.pieces.to_i
            prod8 = orderline8.first.product_list.extproductcode[0..9].upcase
            #customer_order_list.update(prod8: orderline8.first.product_list.extproductcode.truncate(10).upcase, qty8: orderline8.first.pieces.to_i)
          end
          orderline9 = OrderLine.where("orderid = ?", order_id).offset(8)
          if orderline9.present?
            qty9 = orderline9.first.pieces.to_i
            prod9 = orderline9.first.product_list.extproductcode[0..9].upcase
            #customer_order_list.update(prod9: orderline9.first.product_list.extproductcode.truncate(10).upcase, qty9: orderline9.first.pieces.to_i)
          end
          orderline10 = OrderLine.where("orderid = ?", order_id).offset(9)
          # if orderline10.exists?
          #   customer_order_list.update(prod10: orderline10.first.product_variant.extproductcode, qty10: orderline10.first.pieces)
          # end
          if @order_master.customer_address.st.upcase == "MAH"
             qty10 = 1
            prod10 = "2.5"

          end

          #establish_connection "#{Rails.env}_cccrm"

           if Rails.env == "development"
              ActiveRecord::Base.establish_connection :development_cccrm
           elsif Rails.env == "production"
              ActiveRecord::Base.establish_connection :production_cccrm
           end


          #ActiveRecord::Base.establish_connection("#{Rails.env}_cccrm")
          hash =  ActiveRecord::Base.connection.exec_query("select ordernumc.nextval from dual")[0]
          #order_num =  hash["nextval"]

          if Rails.env == "development"
            ActiveRecord::Base.establish_connection :development_testora
          elsif Rails.env == "production"
            ActiveRecord::Base.establish_connection :production_testora
          end
          #ActiveRecord::Base.establish_connection("#{Rails.env}_testora")

          #hash = ActiveRecord::Base.connection.exec_query("select order_seq.nextval from dual")[0]

          order_num =  hash["nextval"]

          #flash[:notice] = "Order Number is #{order_num}"
               #CustomerOrderList Date.current Date.today.in_time_zone Time.zone.now
          customer_order_list = CustomerOrderList.create(ordernum: order_num,
          orderdate: (330.minutes).from_now.to_date,
          title: pro_order_master.customer.salute[0..4].upcase,
          fname: pro_order_master.customer.first_name[0..29].upcase,
          lname: pro_order_master.customer.last_name[0..29].upcase,
          add1: pro_order_master.customer_address.address1[0..29].upcase,
          add2: pro_order_master.customer_address.address2[0..29].upcase,
          add3: (pro_order_master.customer_address.address3[0..29].upcase if pro_order_master.customer_address.address3.present?),
          landmark: pro_order_master.customer_address.landmark[0..49].upcase,
          city: pro_order_master.customer_address.city[0..29].upcase,
          mstate: pro_order_master.customer_address.state[0..49].upcase,
          state: pro_order_master.customer_address.st[0..4].upcase,
          pincode: pro_order_master.customer_address.pincode,
          mstate: pro_order_master.customer_address.state[0..49].upcase,
          tel1: pro_order_master.customer.mobile[0..19].upcase,
          tel2: (pro_order_master.customer_address.telephone2[0..19].upcase if pro_order_master.customer_address.telephone2.present?),
          fax: (pro_order_master.customer_address.fax[0..19].upcase if pro_order_master.customer_address.fax.present?),
          email: (pro_order_master.customer.emailid[0..19].upcase if pro_order_master.customer.emailid.present?),
          ccnumber:  creditcardno,
          expmonth:  expmonth,
          expyear:  expyear,
          cardtype: cardtype,
          carddisc: creditcardcharges,
          ipadd: (pro_order_master.userip[0..49] if pro_order_master.userip.present?),
          dnis: pro_order_master.calledno,
          channel: pro_order_master.medium.name.strip[0..48].upcase,
          chqdisc: pro_order_master.creditcardcharges,
          totalamt: pro_order_master.g_total,
          trandate: Time.zone.now,
          username: (pro_order_master.employee.name[0..49].upcase || current_user.name.truncate(50).upcase if pro_order_master.employee.present?),
          oper_no: pro_order_master.employeecode,
          dt_hour: nowhour,
          dt_min: nowminute,
          uae_status: pro_order_master.customer.gender[0..49].upcase,
          prod1: prod1, prod2: prod2, prod3: prod3, prod4: prod4, prod5: prod5, prod6: prod6, prod7: prod7, prod8:prod8, prod9: prod9, prod10: prod10,
          qty1: qty1, qty2: qty2, qty3: qty3, qty4: qty4, qty5: qty5, qty6: qty6, qty7: qty7, qty8: qty8, qty9: qty9, qty10: qty10)

          #CUSTDETAILS
          customerdetails = CUSTDETAILS.create(ordernum: order_num,
          transfer_ok: 0,
          orderdate: (330.minutes).from_now.to_date,
          title: pro_order_master.customer.salute[0..4].upcase,
          fname: pro_order_master.customer.first_name[0..29].upcase,
          lname: pro_order_master.customer.last_name[0..29].upcase,
          add1: pro_order_master.customer_address.address1[0..29].upcase,
          add2: pro_order_master.customer_address.address2[0..29].upcase,
          add3: (pro_order_master.customer_address.address3[0..29].upcase if pro_order_master.customer_address.address3.present?),
          landmark: pro_order_master.customer_address.landmark[0..49].upcase,
          city: pro_order_master.customer_address.city[0..29].upcase,
          mstate: pro_order_master.customer_address.state[0..49].upcase,
          state: pro_order_master.customer_address.st[0..4].upcase,
          pincode: pro_order_master.customer_address.pincode,
          mstate: pro_order_master.customer_address.state[0..49].upcase,
          tel1: pro_order_master.customer.mobile[0..19].upcase,
          tel2: (pro_order_master.customer_address.telephone2[0..17].upcase if pro_order_master.customer_address.telephone2.present?),
          fax: (pro_order_master.customer_address.fax[0..19].upcase if pro_order_master.customer_address.fax.present?),
          email: (pro_order_master.customer.emailid[0..19].upcase if pro_order_master.customer.emailid.present?),
          ccnumber:  creditcardno,
          expmonth:  expmonth,
          expyear:  expyear,
          cardtype: cardtype,
          carddisc: creditcardcharges,
          ipadd: (pro_order_master.userip[0..49] if pro_order_master.userip.present?),
          dnis: pro_order_master.calledno,
          channel: pro_order_master.medium.name.strip[0..48].upcase,
          chqdisc: pro_order_master.creditcardcharges,
          totalamt: pro_order_master.g_total,
          trandate: Time.zone.now,
          username: (pro_order_master.employee.name[0..49].upcase || current_user.name.truncate(50).upcase if pro_order_master.employee.present?),
          oper_no: pro_order_master.employeecode,
          dt_hour: nowhour,
          dt_min: nowminute,
          uae_status: pro_order_master.customer.gender[0..49].upcase,
          prod1: prod1, prod2: prod2, prod3: prod3, prod4: prod4, prod5: prod5, prod6: prod6, prod7: prod7, prod8:prod8, prod9: prod9, prod10: prod10,
          qty1: qty1, qty2: qty2, qty3: qty3, qty4: qty4, qty5: qty5, qty6: qty6, qty7: qty7, qty8: qty8, qty9: qty9, qty10: qty10)


          #- Integer update with customer order id
          pro_order_master.update(external_order_no: order_num.to_s, order_status_master_id: 10003)

          return order_num.to_s #customer_order_list.ordernum
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

      update_page_trail("The user has searched for a processed order")
      @empcode = current_user.employee_code
      employee_id = Employee.where(employeecode: @empcode).first.id
      if order_master.employee_id != employee_id
         update_page_trail("Unauthorised view of processed order attempted by user #{@empcode}")
      end
      if order_master.order_status_master_id >= 10003
         flash[:error] = "This order no #{orderid} is already processed at #{ondate}"
        redirect_to summary_path(:order_id => @order_master.id)
      end
    end
  end
end
