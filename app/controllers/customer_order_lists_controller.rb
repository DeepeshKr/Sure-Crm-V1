class CustomerOrderListsController < ApplicationController
  before_action :set_customer_order_list, only: [:show, :edit, :update, :destroy, :inoracle]

  respond_to :html

  def index 
    @complete = 'yes'
    if params[:complete].present?
        if params[:complete] = 'yes'
           @customer_order_lists = CustomerOrderList.where("ordernum is not null").order("id DESC").limit(200)
        end
    elsif params[:ordernum].present?
        @ordernum
           @customer_order_lists = CustomerOrderList.where("ordernum = ?", params[:ordernum]).order("id DESC").limit(200)
       
   else
     @customer_order_lists = CustomerOrderList.where(ordernum: nil).order("id DESC").limit(200)
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
        @order_lines = OrderLine.where(orderid: @order_master.id)
      #end 
    end  

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
      creditcardno =  nil
      expmonth = nil
      expyear = nil
      name_on_card = nil
      cardname = nil
      
      order_id = OrderMaster.where(external_order_no: @customer_order_list.ordernum).first.id
      @order_master = OrderMaster.find(order_id)

      t = Time.zone.now
          nowhour = t.strftime('%H').to_i
          #=> returns a 0-padded string of the hour, like "07"
          nowminute = t.strftime('%M').to_i

       creditcardcharges = ''

      if @order_master.orderpaymentmode_id == 10000
        customer_credit_card = CustomerCreditCard.where(customer_id: @order_master.customer_id).last
        creditcardno =  customer_credit_card.card_no.truncate(20)
        expmonth = customer_credit_card.expiry_mon.truncate(20).rjust(2, '0')
        expyear = customer_credit_card.expiry_yr_string.truncate(20).rjust(4, '0')
        cardtype = CreditCard.find_type(creditcardno).truncate(20)
        creditcardcharges = "Y"
      end

      #if @order_master.external_order_no.nil?
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


          ActiveRecord::Base.establish_connection("#{Rails.env}_cccrm")
          hash =  ActiveRecord::Base.connection.exec_query("select ordernumc.nextval from dual")[0]
          #order_num =  hash["nextval"]

          ActiveRecord::Base.establish_connection("#{Rails.env}_testora")
        
          #hash = ActiveRecord::Base.connection.exec_query("select order_seq.nextval from dual")[0]
          
          order_num =  hash["nextval"]

          flash[:notice] = "Order Number is #{order_num}" 
          #CustomerOrderList
          customer_order_list = CustomerOrderList.create(ordernum: order_num,
          orderdate: Time.zone.now,
          title: @order_master.customer.salute[0..4].upcase, 
          fname: @order_master.customer.first_name[0..29].upcase, 
          lname: @order_master.customer.last_name[0..29].upcase, 
          add1: @order_master.customer_address.address1[0..29].upcase, 
          add2: @order_master.customer_address.address2[0..29].upcase, 
          add3: (@order_master.customer_address.address3[0..29].upcase if @order_master.customer_address.address3.present?),
          landmark: @order_master.customer_address.landmark[0..49].upcase, 
          city: @order_master.customer_address.city[0..29].upcase, 
          mstate: @order_master.customer_address.state[0..49].upcase, 
          state: @order_master.customer_address.st[0..4].upcase, 
          pincode: @order_master.customer_address.pincode, 
          mstate: @order_master.customer_address.state[0..49].upcase, 
          tel1: @order_master.customer.mobile[0..19].upcase, 
          tel2: (@order_master.customer_address.telephone1[0..19].upcase if @order_master.customer_address.telephone1.present?),
          fax: (@order_master.customer_address.fax[0..19].upcase if @order_master.customer_address.fax.present?), 
          email: (@order_master.customer.emailid[0..19].upcase if @order_master.customer.emailid.present?), 
          ccnumber:  creditcardno, 
          expmonth:  expmonth, 
          expyear:  expyear, 
          cardtype: cardtype,
          carddisc: creditcardcharges, 
          ipadd: (@order_master.userip[0..49] if @order_master.userip.present?), 
          dnis: @order_master.calledno,
          channel: @order_master.medium.name.strip[0..48].upcase, 
          chqdisc: @order_master.creditcardcharges,
          totalamt: @order_master.subtotal + @order_master.shipping + @order_master.codcharges + @order_master.servicetax + @order_master.maharastracodextra ,
          trandate: Time.zone.now,
          username: (@order_master.employee.name[0..49].upcase || current_user.name.truncate(50).upcase if @order_master.employee.present?),
          oper_no: @order_master.employeecode,
          dt_hour: nowhour,
          dt_min: nowminute,
          uae_status: @order_master.customer.gender[0..49].upcase,
          prod1: prod1, prod2: prod2, prod3: prod3, prod4: prod4, prod5: prod5, prod6: prod6, prod7: prod7, prod8:prod8, prod9: prod9, prod10: prod10,
          qty1: qty1, qty2: qty2, qty3: qty3, qty4: qty4, qty5: qty5, qty6: qty6, qty7: qty7, qty8: qty8, qty9: qty9, qty10: qty10)
      
          #CUSTDETAILS
          customerdetails = CUSTDETAILS.create(ordernum: order_num,
          orderdate: Time.zone.now,
          title: @order_master.customer.salute[0..4].upcase, 
          fname: @order_master.customer.first_name[0..29].upcase, 
          lname: @order_master.customer.last_name[0..29].upcase, 
          add1: @order_master.customer_address.address1[0..29].upcase, 
          add2: @order_master.customer_address.address2[0..29].upcase, 
          add3: 'DIST-' + (@order_master.customer_address.address3[0..17].upcase if @order_master.customer_address.address3.present?) + '-' + @order_master.customer_address.state[0..5].upcase,
          landmark: @order_master.customer_address.landmark[0..49].upcase, 
          city: @order_master.customer_address.city[0..29].upcase, 
          mstate: @order_master.customer_address.state[0..49].upcase, 
          state: @order_master.customer_address.st[0..4].upcase, 
          pincode: @order_master.customer_address.pincode, 
          mstate: @order_master.customer_address.state[0..49].upcase, 
          tel1: @order_master.customer.mobile[0..19].upcase, 
          tel2: (@order_master.customer_address.telephone1[0..19].upcase if @order_master.customer_address.telephone1.present?),
          fax: (@order_master.customer_address.fax[0..19].upcase if @order_master.customer_address.fax.present?), 
          email: (@order_master.customer.emailid[0..19].upcase if @order_master.customer.emailid.present?), 
          ccnumber:  creditcardno, 
          expmonth:  expmonth, 
          expyear:  expyear, 
          cardtype: cardtype,
          carddisc: creditcardcharges, 
          ipadd: (@order_master.userip[0..49] if @order_master.userip.present?), 
          dnis: @order_master.calledno,
          channel: @order_master.medium.name.strip[0..48].upcase, 
          chqdisc: @order_master.creditcardcharges,
          totalamt: @order_master.subtotal + @order_master.shipping + @order_master.codcharges + @order_master.servicetax + @order_master.maharastracodextra ,
          trandate: Time.zone.now,
          username: (@order_master.employee.name[0..49].upcase || current_user.name.truncate(50).upcase if @order_master.employee.present?),
          oper_no: @order_master.employeecode,
          dt_hour: nowhour,
          dt_min: nowminute,
          uae_status: @order_master.customer.gender[0..49].upcase,
          prod1: prod1, prod2: prod2, prod3: prod3, prod4: prod4, prod5: prod5, prod6: prod6, prod7: prod7, prod8:prod8, prod9: prod9, prod10: prod10,
          qty1: qty1, qty2: qty2, qty3: qty3, qty4: qty4, qty5: qty5, qty6: qty6, qty7: qty7, qty8: qty8, qty9: qty9, qty10: qty10)
      
          
          #- Integer update with customer order id
          #@order_master.update(external_order_no: order_num.to_s, order_status_master_id: 10003) 
          flash[:success] = "The order is successfully processed with id: #{order_num}"

          return order_num.to_s #customer_order_list.ordernum
       

      #end
    end
end
