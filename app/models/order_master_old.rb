class OrderMasterOld #< ActiveRecord::Base
  # attr_accessor :grand_total
#   belongs_to :campaign_playlist, foreign_key: "campaign_playlist_id"
#   belongs_to :employee, foreign_key: "employee_id"
#   belongs_to :order_source
#   belongs_to :order_status_master, foreign_key: "order_status_master_id" #, polymorphic: true
#   belongs_to :order_source
#   belongs_to :orderpaymentmode,  foreign_key: "orderpaymentmode_id"
#   belongs_to :customer, foreign_key: "customer_id" #, polymorphic: true
#   belongs_to :customer_address, foreign_key: "customer_address_id" #, polymorphic: true
#   belongs_to :medium, foreign_key: "media_id"
#   belongs_to :promotion, foreign_key: "promotion_id"
#   belongs_to :order_final_status, foreign_key: "order_final_status_id"
#   belongs_to :order_list_mile, foreign_key: "order_last_mile_id"
#
#   has_many :interaction_master, foreign_key: "orderid"
#   has_many :page_trail, foreign_key: "order_id"
#   has_many :order_line, foreign_key: "orderid", :dependent => :destroy
#   has_many :sales_ppo, foreign_key: "order_id"
#   has_many :payumoney_detail, foreign_key: "orderid"
#
#   accepts_nested_attributes_for :order_line,  :allow_destroy => true
#
#   validates_presence_of :calledno , :mobile
#
#   validates_associated :order_line

  #external order
  #order_for_id - Integer update with customer order id
  #external_order_no - string update with customer order id
  
  # after_destroy :updateOrder

  def fullname
      self.customer.fullname if self.customer.present?
  end
  def customer_city
    return self.customer_address.city  if self.customer_address.present?
  end
  def employee_name
    return self.employee.fullname  if self.employee.present?
  end
  def lastvisitpage
    return self.page_trail.name  if self.page_trail.present?
  end

#after_create :on_create

#after_save :on_upate

#after_update :on_update
#external order
#order_for_id - Integer update with customer order id
#external_order_no - string update with customer order id
#external order
#order_for_id - Integer update with customer order id
#external_order_no - string update with customer order id

  def neworder(source, cli, dnis, empcode, empid,request_ip, session_id)

    order_master = OrderMaster.create!(calledno: dnis, order_status_master_id: 10000,
      orderdate: Time.zone.now, pieces: 0,subtotal: 0, taxes: 0, codcharges: 0,
      shipping:0, total: 0, order_source_id: source.to_i, employeecode: empcode,
      employee_id: empid, userip: request_ip, sessionid: session_id,
      order_for_id: 10000, mobile: cli, notes: " ", g_total: 0)

    return order_master
  end

  def duplicate_order(old_order_id)
    old_order_master = OrderMaster.find(old_order_id)

    new_order_master = OrderMaster.create!(calledno: old_order_master.calledno,
      order_status_master_id: 10000,
      orderdate: old_order_master.orderdate,
      customer_id: old_order_master.customer_id,
      customer_address_id: old_order_master.customer_address_id,
      pieces: 0,subtotal: 0,
      taxes: 0, codcharges: 0, shipping:0,
      orderpaymentmode_id:  old_order_master.orderpaymentmode_id,
      total: 0, order_source_id: old_order_master.order_source_id,
      campaign_playlist_id: old_order_master.campaign_playlist_id,
      media_id: old_order_master.media_id,
      employeecode: old_order_master.employeecode,
      employee_id: old_order_master.employee_id,
      userip: request.remote_ip, sessionid: session.id,
      order_for_id: 10000, mobile: old_order_master.mobile,
      original_order_id: old_order_id,
      city: old_order_master.city, pincode: old_order_master.pincode,
      g_total: old_order_master.g_total,
      notes: old_order_master.notes + " Duplicated Order for #{old_order_id}")


    old_order_master.update(original_order_id: old_order_id)

    return new_order_master.id
  end

  def update_customer_order_list(order_id)
      creditcardno =  nil
      expmonth = nil
      expyear = nil
      name_on_card = nil
      cardname = nil

      #order_id = @order_master.id
      pro_order_master = OrderMaster.find(order_id)

      gra_total = pro_order_master.subtotal + pro_order_master.shipping + pro_order_master.codcharges +   pro_order_master.servicetax + pro_order_master.maharastracodextra + pro_order_master.creditcardcharges + pro_order_master.maharastraccextra

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

         orderline1 = OrderLine.where("orderid = ?", order_id).order("order_lines.id")
          .joins(:product_variant)
          .where('PRODUCT_VARIANTS.product_sell_type_id = ?', 10000)

          if orderline1.present?
            qty1 = orderline1.first.pieces.to_i
            prod1 = orderline1.first.product_list.extproductcode[0..9].upcase
            #customer_order_list.update(qty1: qty1, prod1: prod1)
          end

          orderline2 = OrderLine.where("orderid = ?", order_id).order("order_lines.id")
           .joins(:product_variant)
          .where.not('PRODUCT_VARIANTS.product_sell_type_id = ?', 10000).offset(1)
          if orderline2.present?
            qty2 = orderline2.first.pieces.to_i
            prod2 = orderline2.first.product_list.extproductcode[0..9].upcase
            #customer_order_list.update(prod2: prod2, qty2: qty2)
          end
          orderline3 = OrderLine.where("orderid = ?", order_id).order("order_lines.id")
           .joins(:product_variant)
          .where.not('PRODUCT_VARIANTS.product_sell_type_id = ?', 10000).offset(2)

          if orderline3.present?
            qty3 = orderline3.first.pieces.to_i
            prod3 = orderline3.first.product_list.extproductcode[0..9].upcase
            #customer_order_list.update(prod3: orderline3.first.product_list.extproductcode.truncate(10).upcase, qty3: orderline3.first.pieces.to_i)
          end
          orderline4 = OrderLine.where("orderid = ?", order_id).order("order_lines.id")
          .order("order_lines.id")
           .joins(:product_variant)
          .where.not('PRODUCT_VARIANTS.product_sell_type_id = ?', 10000).offset(3)

          if orderline4.present?
            qty4 = orderline4.first.pieces.to_i
            prod4 = orderline4.first.product_list.extproductcode[0..9].upcase
            #customer_order_list.update(prod4: orderline4.first.product_list.extproductcode.truncate(10).upcase, qty4: orderline4.first.pieces.to_i)
          end

          orderline5 = OrderLine.where("orderid = ?", order_id).order("order_lines.id")
           .joins(:product_variant)
          .where.not('PRODUCT_VARIANTS.product_sell_type_id = ?', 10000).offset(4)

          if orderline5.present?
            qty5 = orderline5.first.pieces.to_i
            prod5 = orderline5.first.product_list.extproductcode[0..9].upcase
            #customer_order_list.update(prod5: orderline5.first.product_list.extproductcode.truncate(10).upcase, qty5: orderline5.first.pieces.to_i)
          end
          orderline6 = OrderLine.where("orderid = ?", order_id).order("order_lines.id")
          .joins(:product_variant)
                  .where.not('PRODUCT_VARIANTS.product_sell_type_id = ?', 10000)
                  .offset(5)

          if orderline6.present?
            qty6 = orderline6.first.pieces.to_i
            prod6 = orderline6.first.product_list.extproductcode[0..9].upcase
            #customer_order_list.update(prod6: orderline6.first.product_list.extproductcode.truncate(10).upcase, qty6: orderline6.first.pieces.to_i)
          end
          orderline7 = OrderLine.where("orderid = ?", order_id).order("order_lines.id")
           .joins(:product_variant)
                  .where.not('PRODUCT_VARIANTS.product_sell_type_id = ?', 10000).offset(6)

          if orderline7.present?
            qty7 = orderline7.first.pieces.to_i
            prod7 = orderline7.first.product_list.extproductcode[0..9].upcase
            #customer_order_list.update(prod7: orderline7.first.product_list.extproductcode.truncate(10).upcase, qty7: orderline7.first.pieces.to_i)
          end
          orderline8 = OrderLine.where("orderid = ?", order_id).order("order_lines.id")
           .joins(:product_variant)
          .where.not('PRODUCT_VARIANTS.product_sell_type_id = ?', 10000).offset(7)

          if orderline8.present?
            qty8 = orderline8.first.pieces.to_i
            prod8 = orderline8.first.product_list.extproductcode[0..9].upcase
            #customer_order_list.update(prod8: orderline8.first.product_list.extproductcode.truncate(10).upcase, qty8: orderline8.first.pieces.to_i)
          end
          orderline9 = OrderLine.where("orderid = ?", order_id).order("order_lines.id")
           .joins(:product_variant)
                  .where.not('PRODUCT_VARIANTS.product_sell_type_id = ?', 10000).offset(8)

          if orderline9.present?
            qty9 = orderline9.first.pieces.to_i
            prod9 = orderline9.first.product_list.extproductcode[0..9].upcase
            #customer_order_list.update(prod9: orderline9.first.product_list.extproductcode.truncate(10).upcase, qty9: orderline9.first.pieces.to_i)
          end

          # orderline10 = OrderLine.where("orderid = ?", order_id)
          #           .order("order_lines.id")
          #                   .where.not('PRODUCT_VARIANTS.product_sell_type_id = ?', 10000).offset(9)
    #
          # if orderline10.exists?
          #   customer_order_list.update(prod10: orderline10.first.product_variant.extproductcode, qty10: orderline10.first.pieces)
          # end
          if pro_order_master.customer_address.st.upcase == "MAH"
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
          dept_master = "#{prod1}#{pro_order_master.medium.dept}"
          #flash[:notice] = "Order Number is #{order_num}"
               #CustomerOrderList Date.current Date.today.in_time_zone Time.zone.now
          if CustomerOrderList.where(ordernum: order_num).present?
            customer_order_list = CustomerOrderList.find_by_ordernum(order_num)
           customer_order_list.update(order_id: order_id,
           state_code: pro_order_master.customer_address.state_code,
           dept_master: dept_master,
                      orderdate: (330.minutes).from_now.to_date,
                      title: pro_order_master.customer.salute[0..4].upcase,
                      fname: pro_order_master.customer.first_name[0..29].upcase,
                      lname: pro_order_master.customer.last_name[0..29].upcase,
                      add1: pro_order_master.customer_address.address1[0..29].upcase,
                      add2: pro_order_master.customer_address.address2[0..29].upcase,
                      add3: (pro_order_master.customer_address.address3[0..29].upcase if pro_order_master.customer_address.address3.present?),
                      landmark: pro_order_master.customer_address.landmark[0..49].upcase,
                      city: pro_order_master.customer_address.city[0..29].upcase,
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

          else
          customer_order_list = CustomerOrderList.create(ordernum: order_num,
          order_id: order_id,
          state_code: pro_order_master.customer_address.state_code,
          dept_master: dept_master,
          orderdate: (330.minutes).from_now.to_date,
          title: pro_order_master.customer.salute[0..4].upcase,
          fname: pro_order_master.customer.first_name[0..29].upcase,
          lname: pro_order_master.customer.last_name[0..29].upcase,
          add1: pro_order_master.customer_address.address1[0..29].upcase,
          add2: pro_order_master.customer_address.address2[0..29].upcase,
          add3: (pro_order_master.customer_address.address3[0..29].upcase if pro_order_master.customer_address.address3.present?),
          landmark: pro_order_master.customer_address.landmark[0..49].upcase,
          city: pro_order_master.customer_address.city[0..29].upcase,
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
          end
          #CUSTDETAILS
          #check if already added, then update else add
          if CUSTDETAILS.where(ordernum: order_num).present?
            cust_detail = CUSTDETAILS.find(order_num)
            cust_detail.update(transfer_ok: 0,
            orderdate: (330.minutes).from_now.to_date,
            title: pro_order_master.customer.salute[0..4].upcase,
            fname: pro_order_master.customer.first_name[0..29].upcase,
            lname: pro_order_master.customer.last_name[0..29].upcase,
            add1: pro_order_master.customer_address.address1[0..29].upcase,
            add2: pro_order_master.customer_address.address2[0..29].upcase,
            add3: (pro_order_master.customer_address.address3[0..29].upcase if pro_order_master.customer_address.address3.present?),
            landmark: pro_order_master.customer_address.landmark[0..49].upcase,
            city: pro_order_master.customer_address.city[0..29].upcase,
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

          else

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

          end



          #- Integer update with customer order id
          pro_order_master.update(external_order_no: order_num.to_s, order_status_master_id: 10003)

          return order_num.to_s #customer_order_list.ordernum
      end


  end

  def add_invoice_sms order_id
    this_time = Time.zone.now + 450.minutes
    order_master = OrderMaster.find(old_order_id)

    amount = order_master.grand_total #params[:amount]
    customerName = order_master.customer.salute.upcase order_master.customer.first_name.upcase order_master.customer.last_name.upcase # params[:customerName]

    description = " order ref no #{order_id} to be paid in 2 hrs" #params[:description]
    referenceId = order_master.id #params[:referenceId]
    customerMobileNumber = order_master.mobile #params[:customerMobileNumber]
    confirmSMSPhone = order_master.mobile # params[:confirmSMSPhone]
    url = "https://www.payumoney.com/payment/payment/smsInvoice?"
    encoded_url = URI.encode("amount=#{amount}&customerName=#{customerName}&description=#{description}&referenceId=#{referenceId}&customerMobileNumber=#{customerMobileNumber}&confirmSMSPhone=#{confirmSMSPhone}")

    sms_message = MessageOnOrder.create(customer_id: order_master.customer_id,
      message_status_id: 10000, message_type_id: 10020,
      mobile_no: order_master.mobile,
      order_id: order_id,
      alt_mobile_no: order_master.customer.alt_mobile,
      message: encoded_url,
      long_url: "#{url}#{encoded_url}")

  end

  def process_order order_id
        #this is post in customer order
        order_number = []
        msg = nil
        order_total = 0

      return "No order ref numer " if order_id.blank?

      order_master = OrderMaster.find(order_id)

      order_lines_regular = OrderLine.where(orderid: order_id).joins(:product_variant)
      .where('PRODUCT_VARIANTS.product_sell_type_id = ?', 10000)

      order_lines_basic = OrderLine.where(orderid: order_id).joins(:product_variant)
      .where('product_variants.product_sell_type_id = ?', 10040)

      order_lines_common = OrderLine.where(orderid: order_id).joins(:product_variant)
      .where('product_variants.product_sell_type_id = ?', 10001)

      order_lines_free = OrderLine.where(orderid: order_id).joins(:product_variant)
      .where('product_variants.product_sell_type_id = ?', 10060)

      if order_lines_regular.count > 1
              notices = []
              notice = ""

              new_reg_order_lines =  order_lines_regular.offset(1)

              new_reg_order_lines.each do |order|
                  #create a new order
                  new_order =  duplicate_order(order_id)

                  #switch the order line to new order master
                  #first the regular product
                  order.update(orderid: new_order)
                if order_lines_basic.count > 0
                    list_of_upsells = ProductMasterAddOn.where(product_master_id: order.product_master_id)
                    .pluck(:product_list_id)
                    sold_upsells = order_lines_basic.where(product_list_id: list_of_upsells)
                  if sold_upsells.count > 0
                        sold_upsell = sold_upsells.first
                         #notice +=  "Found a matching product from list of upsell #{sold_upsell.description}"
                        sold_upsell.update(orderid: new_order)
                  end #checked if basic upsell is found to be matching
                end #check if upsell if found

                orderprocessed = update_customer_order_list(new_order)

                #orderprocessed = update_customer_order_list(new_order)
                order_split = OrderMaster.find(new_order)

                order_number << order_split.external_order_no + " for Rs " + order_split.grand_total.to_i.to_s


              end #loop through the order lines Regular
                #save orderline
              orderline_last = OrderLine.where(orderid: order_id)
              orderline_last.each do |ordl|
                ordl.save
              end

              orderprocessed = update_customer_order_list(order_id)

              # order_final = OrderMaster.find(order_id)

              order_number << orderprocessed + " for Rs " + order_master.grand_total.to_i.to_s
              payment_mode_id = order_master.orderpaymentmode_id
              payment_mode_id = payment_mode_id.to_i
              case payment_mode_id
              when 10000 #paid over CC
                msg = ". "
              when 10001
                msg = ". Please pay cash on delivery "
              when 10060 #paid over ATOM CC
                msg = ". "
              when 10080 #paid over Pay u money
                msg = ". "
              end

     else #IF ONLY one regular product found
          # after this is done complete the ordering
          orderprocessed = update_customer_order_list(order_id)

          order_number << orderprocessed  + " for Rs " + order_master.grand_total.to_i.to_s
            payment_mode_id = order_master.orderpaymentmode_id
            payment_mode_id = payment_mode_id.to_i
            case payment_mode_id
            when 10000 #paid over CC
              msg = ". "
            when 10001
              msg = ". Please pay cash on delivery "
            when 10060 #paid over ATOM CC
              msg = ". "
            when 10080 #paid over Pay u money
              msg = ". "
            end

    end

    message = "Thanks for order no #{order_number.join(",")}, products will reach you in 7-10 days#{msg}any queries Call 9223100730 HBN / TELEBRANDS"

    message = message[0..159]
    sms_message = MessageOnOrder.create(customer_id: order_master.customer_id,
      message_status_id: 10000, message_type_id: 10000,
      mobile_no: order_master.customer.mobile,
      alt_mobile_no: order_master.customer.alt_mobile,
      message: message)

    return message

  end # end of process order

  def check_if_paid
    #Please find the Authorization header value for MID-5406244
    #Authorization :- pae1W74vWnCezNDi1oiZ3HJyL7FgzxqfhuTWX5XljYA=
    merchantKey = 5406244
    url ="https://www.payumoney.com/payment/op/getPaymentResponse?"

    pay_u_money = PayumoneyDetail.where("ORDERID IS NOT NULL")

    pay_u_money.each do |pay|
      test_url ="https://test.payumoney.com/payment/op/getPaymentResponse?merchantKey=#{merchantKey}&merchantTransactionIds=#{pay.ORDERID}"
     puts parse_check_paid_uri test_url
    end
    # sample api https://www.payumoney.com/payment/op/getPaymentResponse?merchantKey=xbch78J&merchantTransactionIds=100123abc

  end



def no_order_master(attributes)
  attributes[:id].blank?
end

def timetaken
    ended_on = self.updated_at.to_f
    started_at = self.created_at.to_f
    return (ended_on - started_at).to_i
end

def promo_cost
   #self.promotion
end

def codcharges
    productcost = OrderLine.where('orderid = ?', self.id)
    #return productcost.first.productcost
    if productcost.exists?
      total = 0
      productcost.each do |c|
        total += c.codcharges || 0
      end
      return total.round(2)

    else
      return 0
    end

end

def creditcardcharges
 productcost = OrderLine.where('orderid = ?', self.id)
  #return productcost.first.productcost
  if productcost.exists?
    total = 0
    productcost.each do |c|
      total += c.creditcardcharges || 0
    end
    return total.round(2)

  else
    return 0
  end

end

def maharastracodextra
 productcost = OrderLine.where('orderid = ?', self.id)
  #return productcost.first.productcost
  if productcost.exists?
    total = 0
    productcost.each do |c|
      total += c.maharastracodextra || 0

    end
    return total.round(2)

  else
    return 0
  end

end

def servicetax
  productcost = OrderLine.where('orderid = ?', self.id)
  #return productcost.first.productcost
  if productcost.exists?
    total = 0
    productcost.each do |c|
      total += c.servicetax || 0

    end
    return total.round(2)

  else
    return 0
  end

end

def maharastraccextra
 productcost = OrderLine.where('orderid = ?', self.id)
  #return productcost.first.productcost
  if productcost.exists?
    total = 0
    productcost.each do |c|
      total += c.maharastraccextra || 0

    end
    return total.round(2)

  else
    return 0
  end

end
# 10060 Based on Shipment
# 10020 Based on Orders Generated All orders less estimated cancel rate is used to calculate the commission
# 10021 Based on Paid Order Commission is paid only on all fully paid orders
# 10041 Daily Fixed and Percent on Shipped Orders Daily Fixed and Percent on Shipped Orders for cable TV operators
# 10000 Airtime Purchased Airtime is purchased from the media / operator
# 10040 Daily Fixed and Percent on Paid Orders  For cable TV operators based on fixed daily and Paid Orders
# 10045 Fixed Daily Charges   Only fixed daily charges
def mediacost
    if self.media_id.present?
     media_variable = Medium.where('id = ? AND value is not null', self.media_id)
      .where(:media_commision_id => [10020, 10021, 10040, 10041, 10060]) #.pluck(:value)
      if media_variable.present?
        #discount the total value by 50% as correction
        correction = 0.5
        #PAID_CORRECTION
         if media_variable.first.paid_correction.present?
            correction = media_variable.first.paid_correction #||= 0.5
         end
         #value is the amout to be paid to distributr
          return (((self.subtotal) * 0.888889) * media_variable.first.value.to_f) * correction
      end
  else
    return 0
  end
end

def media_commission
   media_variable = Medium.where('id = ? AND value is not null', self.media_id)
    .where(:media_commision_id => [10020, 10021, 10040, 10041, 10060]) #.pluck(:value)
     if media_variable.present?
         #discount the total value by 50% as media_correction
       media_correction = 0.5
       #PAID_CORRECTION
        if media_variable.first.paid_correction.present?
         media_correction = media_variable.first.paid_correction #||= 0.5
        end
        return ((self.subtotal * 0.888889) * media_variable.first.value.to_f) #* media_correction
      else
        return 0
      end
end

def mediacomission
    if self.media_id.present?
     media_variable = Medium.where('id = ? AND value is not null', self.media_id)
      .where(:media_commision_id => [10020, 10021, 10040, 10041, 10060]) #.pluck(:value)
      if media_variable.present?
        #discount the total value by 50% as correction
        correction = 0.5
        #PAID_CORRECTION
         if media_variable.first.paid_correction.present?
            correction = media_variable.first.paid_correction #||= 0.5
         end
         #value is the amout to be paid to distributr
          return (((self.subtotal) * 0.888889) * media_variable.first.value.to_f) * correction
      end
  else
    return 0
  end
end

def productcost
 productcost = OrderLine.where('orderid = ?', self.id)
  #return productcost.first.productcost
  if productcost.exists?
    total = 0
    productcost.each do |c|
      if c.total > 0
        total += c.productcost
      end
    end
    return total

  else
    return 0
  end

end

def productrevenue
   totalrevenue = 0
    totalrevenue += ((self.subtotal) * 0.888889)|| 0
    totalrevenue += ((self.shipping) * 0.98125)|| 0
     return totalrevenue
end

def grand_total

  return self.subtotal + self.shipping + self.codcharges + self.servicetax + self.maharastracodextra + self.creditcardcharges + self.maharastraccextra

end

def create_hbn_sales_ppo
  #create sales ppo
   sale_ppo = SalesPpo.order("external_order_no").last
   start_order_id = sale_ppo.external_order_no
    order_masters = OrderMaster.where("external_order_no > ?", start_order_id)
    total_orders = order_masters.count
    total_nos, ppos = 0,0
    if order_masters.present?
    	order_masters.each do |order|

        # fix the campaign details here
        order.delay(:queue => 'hbn sales ppos', priority: 100).add_hbn_product_to_campaign
        # create ppo here
        #ppos_c = order.add_hbn_update.delay

        ppos += ppos_c.to_i if ppos_c.present?
        total_nos += 1
      end
    end
    puts "checked about #{total_nos} orders and created #{ppos}"
end

def create_hbn_sales_ppo_between_dates from_date, upto_date #, product_variant_id
  from_date = Date.strptime(args[from_date], "%Y-%m-%d")
  upto_date = Date.strptime(args[upto_date], "%Y-%m-%d")

  (sd).upto(ed).each do |for_date|
    #create sales ppo
      order_masters = OrderMaster.where("TRUNC(orderdate) = ?", for_date)
      total_orders = order_masters.count
      total_nos, ppos = 0,0
      if order_masters.present?
      	order_masters.each do |order|
          # fix the campaign details here
          order.delay(:queue => 'hbn sales ppos', priority: 100).add_hbn_product_to_campaign
          # create ppo here
          # ppos_c = order.add_hbn_update.delay(order.id)
          ppos += ppos_c.to_i if ppos_c.present?
          total_nos += 1
        end
      end
  end
    puts "checked about #{total_nos} orders and created #{ppos}"
end

#required to create ppo
def add_hbn_update
  #create sales ppo for each order line
  order_master = OrderMaster.find(self.id)
  if order_master.medium.blank?
    return puts "Not a HBN Order, skipped!".colorize(:blue)
  end
  if order_master.medium.media_group_id != 10000
    return puts "Not a HBN Order, skipped!".colorize(:blue)
  end
  # .where('ORDER_STATUS_MASTER_ID > 10002')
  if order_master.order_status_master_id < 10002
    return puts "Not a processed order, skipped!".colorize(:blue)
  end

  campaign_playlist_id = order_master.campaign_playlist_id || nil if order_master.campaign_playlist_id.present?
  campaign_id = order_master.campaign_playlist.campaignid || nil if order_master.campaign_playlist
  campaign_name = CampaignPlaylist.find(campaign_playlist_id).name || " " if order_master.campaign_playlist_id.present?
  order_pieces = order_master.pieces || 0 if order_master.pieces.present?
  if order_master.promotion.present?
    if order_master.promotion.promo_cost.present?
      total_promotion_cost = order_master.promotion.promo_cost || 0 if order_master.promotion.promo_cost.present?
      per_order_promo_cost = (total_promotion_cost / order_pieces) if order_pieces.present?
    end
  end

  order_lines = OrderLine.where(orderid: order_id)
  time_of_order = order_master.orderdate.strftime('%Y-%b-%d %H:%M:%S')
  puts "Found #{order_lines.count()} orders, now checking if they are in PPO!".colorize(:blue)
  order_lines.each do |ordln|
  #add or update ppo details
  if SalesPpo.where(:order_line_id=> ordln.id).present?
    @sale_ppo = SalesPpo.where(:order_line_id=> ordln.id).first

    @sale_ppo.update(campaign_playlist_id: campaign_playlist_id,
    name: campaign_name,
    campaign_id: campaign_id,
    :product_master_id => ordln.product_master_id,
    product_variant_id: ordln.productvariant_id,
    product_list_id: ordln.product_list_id,
    prod: (ordln.product_list.extproductcode || nil if ordln.product_list.present?),
    :start_time => time_of_order,
    :order_id => ordln.orderid,
    :order_line_id=> ordln.id,
    :product_cost => ordln.productcost,
    :pieces => ordln.pieces,
    :revenue => ordln.productrevenue,
    :transfer_order_revenue => ordln.transfer_order_revenue,
    :transfer_order_dealer_price => ordln.transfer_order_dealer_price,
    :damages => ordln.productcost * 0.10,
    :returns => ordln.refund,
    :commission_cost => ordln.variable_media_commission,
    :commission_on_order => ordln.fixed_media_commission,
    :promotion_cost=> per_order_promo_cost,
    :gross_sales => ordln.gross_sales,
    :net_sale => ordln.net_sales,
    :external_order_no => order_master.external_order_no,
    :order_status_id => order_master.order_status_master_id,
    :order_pincode => order_master.pincode,
    :media_id => order_master.media_id,
    :promo_cost_total => total_promotion_cost,
    :dnis => order_master.calledno,
    :city => order_master.city,
    :state => order_master.customer_address.state,
    :mobile_no => order_master.mobile,
    :shipping_cost => ordln.product_postage)


    else
      @sale_ppo = SalesPpo.create(name: campaign_name,
      campaign_playlist_id: campaign_playlist_id,
      campaign_id: campaign_id,
      :product_master_id => ordln.product_master_id,
      product_variant_id: ordln.productvariant_id,
      product_list_id: ordln.product_list_id,
      prod: (ordln.product_list.extproductcode || nil if ordln.product_list.present?),
      :start_time => time_of_order,
      :order_id => ordln.orderid,
      :order_line_id => ordln.id,
      :product_cost => ordln.productcost,
      :pieces => ordln.pieces,
      :revenue => ordln.productrevenue,
      :transfer_order_revenue => ordln.transfer_order_revenue,
      :transfer_order_dealer_price => ordln.transfer_order_dealer_price,
      :damages => ordln.productcost * 0.10,
      :returns => ordln.refund,
      :commission_cost => ordln.variable_media_commission,
      :commission_on_order => ordln.fixed_media_commission,
      :promotion_cost=> per_order_promo_cost,
      :gross_sales => ordln.gross_sales,
      :net_sale => ordln.net_sales,
      :external_order_no => order_master.external_order_no,
      :order_status_id => order_master.order_status_master_id,
      :order_pincode => order_master.pincode,
      :media_id => order_master.media_id,
      :promo_cost_total => total_promotion_cost,
      :dnis => order_master.calledno,
      :city => order_master.city,
      :state => order_master.customer_address.state,
      :mobile_no => order_master.mobile,
      :shipping_cost => ordln.product_postage)

    end
  end
end
handle_asynchronously :add_hbn_update, :priority => 100

def add_hbn_product_to_campaign
  #media_id
   order_master = OrderMaster.find(self.id)
   mediumid = order_master.media_id
   missed_reason = nil

   campaign_playlist_id = nil #order_master.campaign_playlist_id || 0 if order_master.campaign_playlist_id.present?

    product_variant = OrderLine.where(orderid: order_id)
    .joins(:product_variant)
   .where('PRODUCT_VARIANTS.product_sell_type_id = ? OR PRODUCT_VARIANTS.product_sell_type_id = ?', 10000, 10040)

    product_variant_id = product_variant.first.productvariant_id || nil if product_variant.first.productvariant_id.present?

    return if product_variant_id.blank?

    ext_product_code = ProductVariant.find(product_variant_id).extproductcode
    order_time = order_master.orderdate + 330.minutes
    nowhour = order_time.strftime('%H').to_i
    nowminute = order_time.strftime('%M').to_i
    todaydate = order_time.strftime("%Y-%m-%d")
    previous_date = (order_time - 1.day).strftime("%Y-%m-%d")
   # max_go_back_date = (todaydate.to_time - 48.hours).to_datetime
    nowsecs = (nowhour * 60 * 60) + (nowminute * 60)
    # check if media is part of HBN group
    # check if media is part of HBN group, if yes, update the HBN group
    # campaign playlist id both ways
    # on order and agains the campaign playlis
    if Medium.where(id: mediumid).present?
      channelname = Medium.find(mediumid).name
      media = Medium.find(mediumid)
      if (media.media_group_id != 10000 || media.media_group_id.blank?)
        order_master.update(campaign_playlist_id: nil)
        add_update order_id
        remove_from_sales_ppo order_id
        return puts "NOT HBN Order removing from order master now" #.colorize(:red)
      end
    end

    #HBN Master Media Id 11200
    #select the campaign from HBN Master Campaign List
    # 2 days restrictions on time travel
    # campaignlist =  Campaign.where(mediumid: 11200).where("TRUNC(startdate) <= ?
    # AND TRUNC(startdate)>= ?", todaydate, max_go_back_date)
    # no restrictions on time travel
    campaignlist =  Campaign.where(mediumid: 11200).where("TRUNC(startdate) <= ?", todaydate).pluck(:id)
    # if !campaignlist.present?
   # cam = CampaignPlaylist.where(productvariantid: product_variant_id, list_status_id: 10000).where("TRUNC(for_date) <= ?", todaydate).order("for_date DESC, start_hr DESC, start_min DESC").where("TRUNC(for_date) <= ? and (start_hr * 60 * 60) + (start_min * 60) <= ?", todaydate, nowsecs).first
   #
   #
   #  end
   # mins = (cam.first.start_hr * 60 * 60) + (cam.first.start_min * 60)
  #  mins = (cam.first.start_hr * 60 * 60) + (cam.first.start_min * 60) 48840
  # (byebug) nowsecs 48780

   campaign_playlist = CampaignPlaylist.where(campaignid: campaignlist)
   .where(list_status_id: 10000).where(productvariantid: product_variant_id)
   .where("(start_hr * 60 * 60) + (start_min * 60) <= ?", nowsecs)
   .where("TRUNC(for_date) = ?", todaydate)
   .order("for_date DESC, start_hr DESC, start_min DESC")
   
   if campaign_playlist.present?

     # update order with campaign playlist id
     campaign_playlist_id = campaign_playlist.first.id if campaign_playlist.first.id.present?
     #order_master.update(campaign_playlist_id: campaign_playlist.first.id)

     puts "#{campaign_playlist_id} Order was for #{order_time.strftime("%d-%b-%Y")} #{nowhour}:#{nowminute} and Regular Campaign #{campaign_playlist.first.for_date.strftime("%d-%b-%Y")} #{campaign_playlist.first.start_hr}:#{campaign_playlist.first.start_min}" if campaign_playlist.present?
     #.colorize(:navy_blue) #puts missed_reason.colorize(:green)
     campaign_updated = "Regular Campaign #{campaign_playlist.first.for_date.strftime("%d-%b-%Y")} #{campaign_playlist.first.start_hr}:#{campaign_playlist.first.start_min}" if campaign_playlist.present?
     
   end
   
    #check for additional product variants in extended file list start 
   if campaign_playlist_id.blank?
       
     extended_campaign_playlist = CampaignPlaylistToProduct.where(product_variant_id: product_variant_id)
     .joins(:campaign_playlist)
     .where("campaign_playlists.list_status_id = 10000")
     .where("(campaign_playlists.start_hr * 60 * 60) + (campaign_playlists.start_min * 60) <= ?", nowsecs)
     .where("TRUNC(campaign_playlists.for_date) = ?", todaydate)
     .order("campaign_playlists.for_date DESC, campaign_playlists.start_hr DESC,
     campaign_playlists.start_min DESC")

    if extended_campaign_playlist.present?
      puts "Found extended campaign playlist #{campaign_playlist_id} in updated order #{order_id}" #..colorize(:white).colorize(:background => :red)
      campaign_playlist_id = extended_campaign_playlist.first.campaign_playlist_id if extended_campaign_playlist.present?
    end      
   end
   
    #check for additional product variants in extended file list end
    # cam = CampaignPlaylist.where(campaignid: campaignlist).where(productvariantid: product_variant_id).where("TRUNC(for_date) <= ?",  todaydate - 1.day).where(list_status_id: 10000).order("for_date DESC, start_hr DESC, start_min DESC")
    # ##############
    #####################
    # older date checks below
    #########################
   #update for earlier date playlists
   if !campaign_playlist_id.present?
     #this is designed for the playlist to go back as as required to assign this order for
     # now with no restrcitions to go back
     older_campaign_playlist = CampaignPlaylist.where(campaignid: campaignlist)
     .where(productvariantid: product_variant_id)
     .where("TRUNC(for_date) <= ?",  previous_date)
     .where(list_status_id: 10000)
     .order("for_date DESC, start_hr DESC, start_min DESC")
     
     if older_campaign_playlist.present?

        missed_reason = "Older campaign used Updated at #{order_time} order for #{channelname} with show #{older_campaign_playlist.name}
        (id #{older_campaign_playlist.first.id} ) at Hour:#{nowhour}  Minutes:#{nowminute}"

        #@order_master.update(campaign_playlist_id: older_campaign_playlist.first.id)
        campaign_playlist_id = older_campaign_playlist.first.id if older_campaign_playlist.first.id.present?

         puts "#{campaign_playlist_id} Order was for #{order_time.strftime("%d-%b-%Y")} #{nowhour}:#{nowminute} and Older Campaign #{older_campaign_playlist.first.for_date.strftime("%d-%b-%Y")} #{older_campaign_playlist.first.start_hr}:#{older_campaign_playlist.first.start_min}" #..colorize(:red) if older_campaign_playlist.present?

         campaign_updated = "Older Campaign #{older_campaign_playlist.first.for_date.strftime("%d-%b-%Y")} #{older_campaign_playlist.first.start_hr}:#{older_campaign_playlist.first.start_min}"  if older_campaign_playlist.present?
     end
   end

    # check for additional product variants for older campaign start
   if campaign_playlist_id.blank?
     extended_older_campaign_playlist = CampaignPlaylistToProduct.where(product_variant_id: product_variant_id)
     .joins(:campaign_playlist)
     .where("campaign_playlists.list_status_id = 10000")
     .where("TRUNC(campaign_playlists.for_date) <= ?",  previous_date)
     .order("campaign_playlists.for_date DESC, campaign_playlists.start_hr DESC,
     campaign_playlists.start_min DESC")

      if extended_older_campaign_playlist.present? && campaign_playlist_id.blank?
       puts "Found campaign playlist #{campaign_playlist_id} in Extended Older Playlist and update this for order #{order_id}" #..colorize(:white).colorize(:background => :red)
       campaign_playlist_id = extended_older_campaign_playlist.first.campaign_playlist_id if extended_older_campaign_playlist.present?
      end
   end
    # check for additional product variants for older campaign end

    if campaign_playlist_id.present?
      puts "Found campaign playlist #{campaign_playlist_id} in older campaign and updated this for order #{order_id}" #.colorize(:blue)
    else
      return puts "NO campaign playlist found in product campaign check" #.colorize(:red)
    end
    
    #total_notes = "nothing done"
    if campaign_playlist_id.present?
      order_master.update(campaign_playlist_id: campaign_playlist_id)
      #total_notes = order_master.notes if  order_master.notes.present?
      #order_master.update(notes: total_notes)
    end

    create_sales_hbn_ppo order_id
end
handle_asynchronously :add_hbn_product_to_campaign, :priority => 100

###### below lines for hbn sales ppo asynchronised ##########
######## duplicate this is delayed job server #####
def add_product_to_campaign_hbn_ppo order_id
    #media_id
    campaign_updated = nil
    order_master = OrderMaster.find(order_id)
    mediumid = order_master.media_id

    campaign_playlist_id = nil #order_master.campaign_playlist_id || 0 if order_master.campaign_playlist_id.present?

    product_variant = OrderLine.where(orderid: order_id)
    .joins(:product_variant)
    .where('PRODUCT_VARIANTS.product_sell_type_id = ? OR PRODUCT_VARIANTS.product_sell_type_id = ?', 10000, 10040)

    product_variant_id = product_variant.first.productvariant_id if product_variant.present?

    order_time = order_master.orderdate + 330.minutes
    nowhour = order_time.strftime('%H').to_i
    nowminute = order_time.strftime('%M').to_i
    todaydate = order_time

    max_go_back_date = (todaydate.to_time - 48.hours).to_datetime
    nowsecs = (nowhour * 60 * 60) + (nowminute * 60)

    if Medium.where(id: mediumid).present?
       channelname = Medium.find(mediumid).name
       puts "Found channel: #{channelname}"
       media = Medium.find(mediumid)
      if (media.media_group_id != 10000 || media.media_group_id.blank?)
        order_master.update(campaign_playlist_id: nil)
        add_update order_id
        return puts "NOT HBN Order removing from order master now"
      end
    end
    #HBN Master Media Id 11200
    #select the campaign from HBN Master Campaign List
    # 2 days restrictions on time travel
    # campaignlist =  Campaign.where(mediumid: 11200).where("TRUNC(startdate) <= ?
    # AND TRUNC(startdate)>= ?", todaydate, max_go_back_date)
    # no restrictions on time travel
    campaignlist =  Campaign.where(mediumid: 11200).where("TRUNC(startdate) <= ?", todaydate)
    # if !campaignlist.present?
   #
   #  end


    campaign_playlist = CampaignPlaylist.where(campaignid: campaignlist)
    .where(list_status_id: 10000).where(productvariantid: product_variant_id)
    .where("(start_hr * 60 * 60) + (start_min * 60) <= ?", nowsecs)
    .where("TRUNC(for_date) <= ?", todaydate)
    .order("for_date DESC, start_hr DESC, start_min DESC")

    if campaign_playlist.present?

      # update order with campaign playlist id
      campaign_playlist_id = campaign_playlist.first.id if campaign_playlist.first.id.present?
      #order_master.update(campaign_playlist_id: campaign_playlist.first.id)

      # puts "#{campaign_playlist_id} Order was for #{order_time.strftime("%d-%b-%Y")} #{nowhour}:#{nowminute} and Regular Campaign #{campaign_playlist.first.for_date.strftime("%d-%b-%Y")} #{campaign_playlist.first.start_hr}:#{campaign_playlist.first.start_min}" if campaign_playlist.present?

      campaign_updated = "Regular Campaign #{campaign_playlist.first.for_date.strftime("%d-%b-%Y")} #{campaign_playlist.first.start_hr}:#{campaign_playlist.first.start_min}" if campaign_playlist.present?
    end

    if campaign_playlist_id.blank?
     #check for additional product variants
       extended_campaign_playlist = CampaignPlaylistToProduct.where(product_variant_id: product_variant_id)
       .joins(:campaign_playlist)
       .where("campaign_playlists.list_status_id = 10000")
       .where("(campaign_playlists.start_hr * 60 * 60) + (campaign_playlists.start_min * 60) <= ?", nowsecs)
       .where("TRUNC(campaign_playlists.for_date) <= ?", todaydate)
       .order("campaign_playlists.for_date DESC, campaign_playlists.start_hr DESC,
       campaign_playlists.start_min DESC")

      if extended_campaign_playlist.present?
        puts "Found campaign playlist #{campaign_playlist_id} in Extended Playlist and update this for order #{order_id}"
        campaign_playlist_id = extended_campaign_playlist.first.campaign_playlist_id if extended_campaign_playlist.present?
        campaign_updated = " Externded Campaign Added"
      end
    end
     #update for earlier date playlists
    if !campaign_playlist_id.present?
      #this is designed for the playlist to go back as as required to assign this order for
      # a particular date
      # older_campaign_playlist = CampaignPlaylist.where(productvariantid: product_variant_id)
      # .where("TRUNC(for_date) <= ? AND TRUNC(for_date) >= ?",  todaydate - 1.day, max_go_back_date)
      # .where(list_status_id: 10000)
      # .order("for_date DESC, start_hr DESC, start_min DESC")
      # now with no restrcitions to go back
      older_campaign_playlist = CampaignPlaylist.where(campaignid: campaignlist)
      .where(productvariantid: product_variant_id)
      .where("TRUNC(for_date) <= ?",  todaydate - 1.day)
      .where(list_status_id: 10000)
      .order("for_date DESC, start_hr DESC, start_min DESC")

      if older_campaign_playlist.present?

         missed_reason = "Older campaign used Updated at #{order_time} order for #{channelname} with show #{older_campaign_playlist.name}
         (id #{older_campaign_playlist.first.id} ) at Hour:#{nowhour}  Minutes:#{nowminute}"

         #@order_master.update(campaign_playlist_id: older_campaign_playlist.first.id)
         campaign_playlist_id = older_campaign_playlist.first.id if older_campaign_playlist.first.id.present?

          # puts "#{campaign_playlist_id} Order was for #{order_time.strftime("%d-%b-%Y")} #{nowhour}:#{nowminute} and Older Campaign #{older_campaign_playlist.first.for_date.strftime("%d-%b-%Y")} #{older_campaign_playlist.first.start_hr}:#{older_campaign_playlist.first.start_min}" if older_campaign_playlist.present?

          campaign_updated = "Older Campaign #{older_campaign_playlist.first.for_date.strftime("%d-%b-%Y")} #{older_campaign_playlist.first.start_hr}:#{older_campaign_playlist.first.start_min}"  if older_campaign_playlist.present?
      end
    end

    if campaign_playlist_id.blank?
     #check for additional product variants
     extended_older_campaign_playlist = CampaignPlaylistToProduct.where(product_variant_id: product_variant_id)
     .joins(:campaign_playlist)
     .where("campaign_playlists.list_status_id = 10000")
     .where("TRUNC(campaign_playlists.for_date) <= ?",  todaydate - 1.day)
     .order("campaign_playlists.for_date DESC, campaign_playlists.start_hr DESC,
     campaign_playlists.start_min DESC")

       if extended_campaign_playlist.present? && campaign_playlist_id.blank?
          puts "Found campaign playlist #{campaign_playlist_id} in Extended Older Playlist and update this for order #{order_id}"
        campaign_playlist_id = extended_older_campaign_playlist.first.campaign_playlist_id if extended_older_campaign_playlist.present?
        campaign_updated = "Older Externded Campaign Added"
       end
    end

    if !campaign_playlist_id.present?
       return puts "NO campaign playlist found in product campaign check"
    end


    if campaign_playlist_id.present?
      order_master.update(campaign_playlist_id: campaign_playlist_id)
      #total_notes = "#{order_master.notes} #{campaign_updated}"
      #total_notes = order_master.notes + " " +
      order_master.update(notes: total_notes)

      #check if found in sales ppo table
      create_sales_hbn_ppo order_id

      puts "Process Completed - Updated"
    end

end
handle_asynchronously :add_product_to_campaign_hbn_ppo, :priority => 100

def create_sales_hbn_ppo order_id
 #order_id = self.order_id
     #create sales ppo for each order line
  order_master = OrderMaster.find(order_id)

  return puts "No media Order, skipped!"  if order_master.medium.blank?

  return puts "Not a HBN Order, skipped!" if order_master.medium.media_group_id != 10000

  return puts "Not a processed order, skipped!" if order_master.order_status_master_id < 10001

   campaign_playlist_id = order_master.campaign_playlist_id || nil if order_master.campaign_playlist_id.present?
   campaign_id = order_master.campaign_playlist.campaignid || nil if order_master.campaign_playlist

  return  puts "No campaign playlist found in PPO"  if campaign_playlist_id.blank?

   campaign_name = CampaignPlaylist.find(campaign_playlist_id).name || " " if order_master.campaign_playlist_id.present?
   order_pieces = order_master.pieces || 0 if order_master.pieces.present?

   if order_master.promotion.present?
     if order_master.promotion.promo_cost.present?
       total_promotion_cost = order_master.promotion.promo_cost || 0 if order_master.promotion.promo_cost.present?
       per_order_promo_cost = (total_promotion_cost / order_pieces) if order_pieces.present?
     end
   end

   order_lines = OrderLine.where(orderid: order_id)
   time_of_order = order_master.orderdate.strftime('%Y-%b-%d %H:%M:%S')
   puts "Found #{order_lines.count()} orders, now checking if they are in PPO!"
   order_lines.each do |ordln|
   #add or update ppo details
   if SalesPpo.where(:order_line_id=> ordln.id).present?
     @sale_ppo = SalesPpo.where(:order_line_id=> ordln.id).first

     @sale_ppo.update(campaign_playlist_id: campaign_playlist_id,
     name: campaign_name,
     campaign_id: campaign_id,
     :product_master_id => ordln.product_master_id,
     product_variant_id: ordln.productvariant_id,
     product_list_id: ordln.product_list_id,
     prod: (ordln.product_list.extproductcode || nil if ordln.product_list.present?),
     :start_time => time_of_order,
     :order_id => ordln.orderid,
     :order_line_id=> ordln.id,
     :product_cost => ordln.productcost,
     :pieces => ordln.pieces,
     :revenue => ordln.productrevenue,
     :transfer_order_revenue => ordln.transfer_order_revenue,
     :transfer_order_dealer_price => ordln.transfer_order_dealer_price,
     :damages => ordln.productcost * 0.10,
     :returns => ordln.refund,
     :commission_cost => ordln.variable_media_commission,
     :commission_on_order => ordln.fixed_media_commission,
     :promotion_cost=> per_order_promo_cost,
     :gross_sales => ordln.gross_sales,
     :net_sale => ordln.net_sales,
     :external_order_no => order_master.external_order_no,
     :order_status_id => order_master.order_status_master_id,
     :order_pincode => order_master.pincode,
     :media_id => order_master.media_id,
     :promo_cost_total => total_promotion_cost,
     :dnis => order_master.calledno,
     :city => order_master.city,
     :state => order_master.customer_address.state,
     :mobile_no => order_master.mobile,
     :shipping_cost => ordln.product_postage)

     puts "Created NEW Sales PPO with id #{@sale_ppo.id} created on #{@sale_ppo.created_at.strftime("%d-%b-%y %H:%M")} for order id #{order_master.id}"

     else
       @sale_ppo = SalesPpo.create(name: campaign_name,
       campaign_playlist_id: campaign_playlist_id,
       campaign_id: campaign_id,
       :product_master_id => ordln.product_master_id,
       product_variant_id: ordln.productvariant_id,
       product_list_id: ordln.product_list_id,
       prod: (ordln.product_list.extproductcode || nil if ordln.product_list.present?),
       :start_time => time_of_order,
       :order_id => ordln.orderid,
       :order_line_id => ordln.id,
       :product_cost => ordln.productcost,
       :pieces => ordln.pieces,
       :revenue => ordln.productrevenue,
       :transfer_order_revenue => ordln.transfer_order_revenue,
       :transfer_order_dealer_price => ordln.transfer_order_dealer_price,
       :damages => ordln.productcost * 0.10,
       :returns => ordln.refund,
       :commission_cost => ordln.variable_media_commission,
       :commission_on_order => ordln.fixed_media_commission,
       :promotion_cost=> per_order_promo_cost,
       :gross_sales => ordln.gross_sales,
       :net_sale => ordln.net_sales,
       :external_order_no => order_master.external_order_no,
       :order_status_id => order_master.order_status_master_id,
       :order_pincode => order_master.pincode,
       :media_id => order_master.media_id,
       :promo_cost_total => total_promotion_cost,
       :dnis => order_master.calledno,
       :city => order_master.city,
       :state => order_master.customer_address.state,
       :mobile_no => order_master.mobile,
       :shipping_cost => ordln.product_postage)

       return puts "Updated existing Sales PPO with id #{@sale_ppo.id} created on #{@sale_ppo.created_at.strftime("%d-%b-%y %H:%M")} for order id #{order_master.id}"
     end

  end
end
handle_asynchronously :create_sales_hbn_ppo, :priority => 100
######## duplicate this is delayed job server #####

def re_create_sales_ppo
  order_id = self.id
 #order_id = self.order_id
     #create sales ppo for each order line
   order_master = OrderMaster.find(order_id)
   if order_master.medium.blank?
     # remove_from_sales_ppo order_id
     return puts "Not a HBN Order, skipped!" #.colorize(:blue)
   end
   if order_master.medium.media_group_id != 10000
     remove_from_sales_ppo order_id
     return puts "Not a HBN Order, skipped!" #.colorize(:red)
   end
   # .where('ORDER_STATUS_MASTER_ID > 10002')
   if order_master.order_status_master_id < 10001
     remove_from_sales_ppo order_id
     return puts "Not a processed order, skipped!" #.colorize(:red)
   end

   campaign_playlist_id = order_master.campaign_playlist_id || nil if order_master.campaign_playlist_id.present?
   campaign_id = order_master.campaign_playlist.campaignid || nil if order_master.campaign_playlist
   if campaign_playlist_id.present?
     puts "Found campaign playlist #{campaign_playlist_id} and update this for order #{order_id} IN PPO" #.colorize(:blue)
   else
     remove_from_sales_ppo order_id
   return  puts "No campaign playlist found in PPO" #.colorize(:red)

   end
   campaign_name = CampaignPlaylist.find(campaign_playlist_id).name || " " if order_master.campaign_playlist_id.present?
   order_pieces = order_master.pieces || 0 if order_master.pieces.present?
   if order_master.promotion.present?
     if order_master.promotion.promo_cost.present?
       total_promotion_cost = order_master.promotion.promo_cost || 0 if order_master.promotion.promo_cost.present?
       per_order_promo_cost = (total_promotion_cost / order_pieces) if order_pieces.present?
     end
   end

   order_lines = OrderLine.where(orderid: order_id)
   time_of_order = order_master.orderdate.strftime('%Y-%b-%d %H:%M:%S')
   puts "Found #{order_lines.count()} orders, now checking if they are in PPO!" #.colorize(:blue)
   order_lines.each do |ordln|
   #add or update ppo details
   if SalesPpo.where(:order_line_id=> ordln.id).present?
     @sale_ppo = SalesPpo.where(:order_line_id=> ordln.id).first

     @sale_ppo.update(campaign_playlist_id: campaign_playlist_id,
     name: campaign_name,
     campaign_id: campaign_id,
     :product_master_id => ordln.product_master_id,
     product_variant_id: ordln.productvariant_id,
     product_list_id: ordln.product_list_id,
     prod: (ordln.product_list.extproductcode || nil if ordln.product_list.present?),
     :start_time => time_of_order,
     :order_id => ordln.orderid,
     :order_line_id=> ordln.id,
     :product_cost => ordln.productcost,
     :pieces => ordln.pieces,
     :revenue => ordln.productrevenue,
     :transfer_order_revenue => ordln.transfer_order_revenue,
     :transfer_order_dealer_price => ordln.transfer_order_dealer_price,
     :damages => ordln.productcost * 0.10,
     :returns => ordln.refund,
     :commission_cost => ordln.variable_media_commission,
     :commission_on_order => ordln.fixed_media_commission,
     :promotion_cost=> per_order_promo_cost,
     :gross_sales => ordln.gross_sales,
     :net_sale => ordln.net_sales,
     :external_order_no => order_master.external_order_no,
     :order_status_id => order_master.order_status_master_id,
     :order_pincode => order_master.pincode,
     :media_id => order_master.media_id,
     :promo_cost_total => total_promotion_cost,
     :dnis => order_master.calledno,
     :city => order_master.city,
     :state => order_master.customer_address.state,
     :mobile_no => order_master.mobile,
     :shipping_cost => ordln.product_postage)

     puts "Updated existing Sales PPO with id #{@sale_ppo.id} created on #{@sale_ppo.created_at.strftime("%d-%b-%y %H:%M")} for order id #{order_master.id}" #.colorize(:light_yellow).colorize( :background => :black)
     end
   end
end
handle_asynchronously :re_create_sales_ppo, :priority => 100

def add_product_to_campaign
  order_id = self.id
   #media_id
   order_master = OrderMaster.find(order_id)
   mediumid = order_master.media_id
   missed_reason = nil

   campaign_playlist_id = order_master.campaign_playlist_id || 0 if order_master.campaign_playlist_id.present?
   product_variant = OrderLine.where(orderid: order_id).joins(:product_variant).where('PRODUCT_VARIANTS.product_sell_type_id = ? OR PRODUCT_VARIANTS.product_sell_type_id = ?', 10000, 10040)
 
   product_variant_id = product_variant.first.productvariant_id || nil if product_variant.first.productvariant_id.present?

   return if product_variant_id.blank?

   ext_product_code = ProductVariant.find(product_variant_id).extproductcode
   order_time = order_master.orderdate + 330.minutes
   nowhour = order_time.strftime('%H').to_i
   nowminute = order_time.strftime('%M').to_i
   todaydate = order_time.strftime("%Y-%m-%d")
   previous_date = (order_time - 1.day).strftime("%Y-%m-%d")
  # max_go_back_date = (todaydate.to_time - 48.hours).to_datetime
   nowsecs = (nowhour * 60 * 60) + (nowminute * 60)
   # check if media is part of HBN group
   # check if media is part of HBN group, if yes, update the HBN group
   # campaign playlist id both ways
   # on order and agains the campaign playlis
   if Medium.where(id: mediumid).present?
     channelname = Medium.find(mediumid).name
     media = Medium.find(mediumid)
     if (media.media_group_id != 10000 || media.media_group_id.blank?)
       order_master.update(campaign_playlist_id: nil)
       add_update order_id
       remove_from_sales_ppo order_id
       return puts "NOT HBN Order removing from order master now" #.colorize(:red)
     end
   end

   #HBN Master Media Id 11200
   #select the campaign from HBN Master Campaign List
   # 2 days restrictions on time travel
   # campaignlist =  Campaign.where(mediumid: 11200).where("TRUNC(startdate) <= ?
   # AND TRUNC(startdate)>= ?", todaydate, max_go_back_date)
   # no restrictions on time travel
   campaignlist =  Campaign.where(mediumid: 11200).where("TRUNC(startdate) <= ?", todaydate).pluck(:id)
   # if !campaignlist.present?
  # cam = CampaignPlaylist.where(productvariantid: product_variant_id, list_status_id: 10000).where("TRUNC(for_date) <= ?", todaydate).order("for_date DESC, start_hr DESC, start_min DESC").where("TRUNC(for_date) <= ? and (start_hr * 60 * 60) + (start_min * 60) <= ?", todaydate, nowsecs).first
  #
  #
  #  end
  # mins = (cam.first.start_hr * 60 * 60) + (cam.first.start_min * 60)
 #  mins = (cam.first.start_hr * 60 * 60) + (cam.first.start_min * 60) 48840
 # (byebug) nowsecs 48780

  campaign_playlist = CampaignPlaylist.where(campaignid: campaignlist)
  .where(list_status_id: 10000).where(productvariantid: product_variant_id)
  .where("(start_hr * 60 * 60) + (start_min * 60) <= ?", nowsecs)
  .where("TRUNC(for_date) = ?", todaydate)
  .order("for_date DESC, start_hr DESC, start_min DESC")
  
  if campaign_playlist.present?

    # update order with campaign playlist id
    campaign_playlist_id = campaign_playlist.first.id if campaign_playlist.first.id.present?
    #order_master.update(campaign_playlist_id: campaign_playlist.first.id)

    puts "#{campaign_playlist_id} Order was for #{order_time.strftime("%d-%b-%Y")} #{nowhour}:#{nowminute} and Regular Campaign #{campaign_playlist.first.for_date.strftime("%d-%b-%Y")} #{campaign_playlist.first.start_hr}:#{campaign_playlist.first.start_min}" if campaign_playlist.present?
    #.colorize(:navy_blue) #puts missed_reason.colorize(:green)
    campaign_updated = "Regular Campaign #{campaign_playlist.first.for_date.strftime("%d-%b-%Y")} #{campaign_playlist.first.start_hr}:#{campaign_playlist.first.start_min}" if campaign_playlist.present?
    
  end
  
   #check for additional product variants in extended file list start 
  if campaign_playlist_id.blank?
    puts "Missed simple first campaign when checked for #{todaydate} and #{nowsecs} for #{campaign_playlist.first.for_date.strftime("%d-%b-%Y")} and #{(campaign_playlist.first.start_hr.to_i * 60 * 60) + (campaign_playlist.first.start_min.to_i * 60)} now checking for extended product list "
    
    extended_campaign_playlist = CampaignPlaylistToProduct.where(product_variant_id: product_variant_id)
    .joins(:campaign_playlist)
    .where("campaign_playlists.list_status_id = 10000")
    .where("(campaign_playlists.start_hr * 60 * 60) + (campaign_playlists.start_min * 60) <= ?", nowsecs)
    .where("TRUNC(campaign_playlists.for_date) = ?", todaydate)
    .order("campaign_playlists.for_date DESC, campaign_playlists.start_hr DESC,
    campaign_playlists.start_min DESC")

   if extended_campaign_playlist.present?
     puts "Found extended campaign playlist #{campaign_playlist_id} in updated order #{order_id}" #..colorize(:white).colorize(:background => :red)
     campaign_playlist_id = extended_campaign_playlist.first.campaign_playlist_id if extended_campaign_playlist.present?
   end      
  end
  
   #check for additional product variants in extended file list end
   # cam = CampaignPlaylist.where(campaignid: campaignlist).where(productvariantid: product_variant_id).where("TRUNC(for_date) <= ?",  todaydate - 1.day).where(list_status_id: 10000).order("for_date DESC, start_hr DESC, start_min DESC")
   # ##############
   #####################
   # older date checks below
   #########################
  #update for earlier date playlists
  if !campaign_playlist_id.present?
    #this is designed for the playlist to go back as as required to assign this order for
    # now with no restrcitions to go back
    older_campaign_playlist = CampaignPlaylist.where(campaignid: campaignlist)
    .where(productvariantid: product_variant_id)
    .where("TRUNC(for_date) <= ?",  previous_date)
    .where(list_status_id: 10000)
    .order("for_date DESC, start_hr DESC, start_min DESC")
    
    if older_campaign_playlist.present?

       missed_reason = "Older campaign used Updated at #{order_time} order for #{channelname} with show #{older_campaign_playlist.name}
       (id #{older_campaign_playlist.first.id} ) at Hour:#{nowhour}  Minutes:#{nowminute}"

       #@order_master.update(campaign_playlist_id: older_campaign_playlist.first.id)
       campaign_playlist_id = older_campaign_playlist.first.id if older_campaign_playlist.first.id.present?

        puts "#{campaign_playlist_id} Order was for #{order_time.strftime("%d-%b-%Y")} #{nowhour}:#{nowminute} and Older Campaign #{older_campaign_playlist.first.for_date.strftime("%d-%b-%Y")} #{older_campaign_playlist.first.start_hr}:#{older_campaign_playlist.first.start_min}" #..colorize(:red) if older_campaign_playlist.present?

        campaign_updated = "Older Campaign #{older_campaign_playlist.first.for_date.strftime("%d-%b-%Y")} #{older_campaign_playlist.first.start_hr}:#{older_campaign_playlist.first.start_min}"  if older_campaign_playlist.present?
    end
  end
  byebug
   # check for additional product variants for older campaign start
  if campaign_playlist_id.blank?
    extended_older_campaign_playlist = CampaignPlaylistToProduct.where(product_variant_id: product_variant_id)
    .joins(:campaign_playlist)
    .where("campaign_playlists.list_status_id = 10000")
    .where("TRUNC(campaign_playlists.for_date) <= ?",  previous_date)
    .order("campaign_playlists.for_date DESC, campaign_playlists.start_hr DESC,
    campaign_playlists.start_min DESC")

       if extended_older_campaign_playlist.present? && campaign_playlist_id.blank?
        puts "Found campaign playlist #{campaign_playlist_id} in Extended Older Playlist and update this for order #{order_id}" #..colorize(:white).colorize(:background => :red)
        campaign_playlist_id = extended_older_campaign_playlist.first.campaign_playlist_id if extended_older_campaign_playlist.present?
       end
  end
   # check for additional product variants for older campaign end

   if campaign_playlist_id.present?
     puts "Found campaign playlist #{campaign_playlist_id} in older campaign and updated this for order #{order_id}" #.colorize(:blue)
   else
     return puts "NO campaign playlist found in product campaign check" #.colorize(:red)
   end

   if campaign_playlist_id.present?
     order_master.update(campaign_playlist_id: campaign_playlist_id)
     #total_notes = order_master.notes + " " + campaign_updated
     #order_master.update(notes: total_notes)

      #check if found in sales ppo table
      puts 'hbn sales ppos over rake'
    # order_master.delay(:queue => 'hbn sales ppos over take', priority: 100).re_create_sales_ppo
     add_hbn_update order_id
     puts "Process Completed - Updated"
   end
   
end
handle_asynchronously :add_product_to_campaign, :priority => 100

def remove_from_sales_ppo order_id
  order_master = OrderMaster.find(order_id)

  # if order_master.medium.media_group_id == 10000
 #    return puts "A HBN Order, skipped!".colorize(:blue)
 #  end
 #  # .where('ORDER_STATUS_MASTER_ID > 10002')
 #  if order_master.order_status_master_id > 10002
 #    return puts "A processed order, skipped!".colorize(:blue)
 #  end

  order_lines = OrderLine.where(orderid: order_id)
  order_lines.each do |ordln|
  #add or update ppo details
    if SalesPpo.where(:order_line_id=> ordln.id).present?
      sale_ppo = SalesPpo.where(:order_line_id=> ordln.id).first
      sale_ppo.destroy
      puts "Destroyed for order id #{order_master.id}" #.colorize(:black).colorize(:background => :red)
    end
  end
end
handle_asynchronously :remove_from_sales_ppo, :priority => 100

def add_update order_id
  #create sales ppo for each order line
  order_master = OrderMaster.find(order_id)
  if order_master.medium.blank?
    return puts "Not a HBN Order, skipped!" #.colorize(:blue)
  end
  if order_master.medium.media_group_id != 10000
    return puts "Not a HBN Order, skipped!" #.colorize(:blue)
  end
  # .where('ORDER_STATUS_MASTER_ID > 10002')
  if order_master.order_status_master_id < 10002
    return puts "Not a processed order, skipped!" #.colorize(:blue)
  end

  campaign_playlist_id = order_master.campaign_playlist_id || nil if order_master.campaign_playlist_id.present?
  if campaign_playlist_id.blank?
    return
  end

  campaign_id = order_master.campaign_playlist.campaignid || nil if order_master.campaign_playlist
  campaign_name = CampaignPlaylist.find(campaign_playlist_id).name || " " if order_master.campaign_playlist_id.present?
  order_pieces = order_master.pieces || 0 if order_master.pieces.present?
  if order_master.promotion.present?
    if order_master.promotion.promo_cost.present?
      total_promotion_cost = order_master.promotion.promo_cost || 0 if order_master.promotion.promo_cost.present?
      per_order_promo_cost = (total_promotion_cost / order_pieces) if order_pieces.present?
    end
  end

  order_lines = OrderLine.where(orderid: order_id)
  time_of_order = order_master.orderdate.strftime('%Y-%b-%d %H:%M:%S')
  puts "Found #{order_lines.count()} orders, now checking if they are in PPO!" #.colorize(:blue)
  order_lines.each do |ordln|
  #add or update ppo details
  if SalesPpo.where(:order_line_id=> ordln.id).present?
    @sale_ppo = SalesPpo.where(:order_line_id=> ordln.id).first

    @sale_ppo.update(campaign_playlist_id: campaign_playlist_id,
    name: campaign_name,
    campaign_id: campaign_id,
    :product_master_id => ordln.product_master_id,
    product_variant_id: ordln.productvariant_id,
    product_list_id: ordln.product_list_id,
    prod: (ordln.product_list.extproductcode || nil if ordln.product_list.present?),
    :start_time => time_of_order,
    :order_id => ordln.orderid,
    :order_line_id=> ordln.id,
    :product_cost => ordln.productcost,
    :pieces => ordln.pieces,
    :revenue => ordln.productrevenue,
    :transfer_order_revenue => ordln.transfer_order_revenue,
    :transfer_order_dealer_price => ordln.transfer_order_dealer_price,
    :damages => ordln.productcost * 0.10,
    :returns => ordln.refund,
    :commission_cost => ordln.variable_media_commission,
    :commission_on_order => ordln.fixed_media_commission,
    :promotion_cost=> per_order_promo_cost,
    :gross_sales => ordln.gross_sales,
    :net_sale => ordln.net_sales,
    :external_order_no => order_master.external_order_no,
    :order_status_id => order_master.order_status_master_id,
    :order_pincode => order_master.pincode,
    :media_id => order_master.media_id,
    :promo_cost_total => total_promotion_cost,
    :dnis => order_master.calledno,
    :city => order_master.city,
    :state => order_master.customer_address.state,
    :mobile_no => order_master.mobile,
    :shipping_cost => ordln.product_postage)


    else
      @sale_ppo = SalesPpo.create(name: campaign_name,
      campaign_playlist_id: campaign_playlist_id,
      campaign_id: campaign_id,
      :product_master_id => ordln.product_master_id,
      product_variant_id: ordln.productvariant_id,
      product_list_id: ordln.product_list_id,
      prod: (ordln.product_list.extproductcode || nil if ordln.product_list.present?),
      :start_time => time_of_order,
      :order_id => ordln.orderid,
      :order_line_id => ordln.id,
      :product_cost => ordln.productcost,
      :pieces => ordln.pieces,
      :revenue => ordln.productrevenue,
      :transfer_order_revenue => ordln.transfer_order_revenue,
      :transfer_order_dealer_price => ordln.transfer_order_dealer_price,
      :damages => ordln.productcost * 0.10,
      :returns => ordln.refund,
      :commission_cost => ordln.variable_media_commission,
      :commission_on_order => ordln.fixed_media_commission,
      :promotion_cost=> per_order_promo_cost,
      :gross_sales => ordln.gross_sales,
      :net_sale => ordln.net_sales,
      :external_order_no => order_master.external_order_no,
      :order_status_id => order_master.order_status_master_id,
      :order_pincode => order_master.pincode,
      :media_id => order_master.media_id,
      :promo_cost_total => total_promotion_cost,
      :dnis => order_master.calledno,
      :city => order_master.city,
      :state => order_master.customer_address.state,
      :mobile_no => order_master.mobile,
      :shipping_cost => ordln.product_postage)

      return 1
    end
  end
end
handle_asynchronously :add_update, :priority => 1000

###### above lines for hbn sales ppo asynchronised ##########
def hbn_trans_detail
   trans_detail = TransDetails.find_by_order_no(self.external_order_no)
   return trans_detail if trans_detail.present?
end
  private
  def on_create
    #self.update_column(pieces: 0,subtotal: 0, taxes: 0, codcharges: 0, shipping:0, total: 0)
    self.update(pieces: OrderLine.where('orderid = ?', self.id).sum(:pieces),
     subtotal: OrderLine.where('orderid = ?', self.id).sum(:subtotal),
     shipping: OrderLine.where('orderid = ?', self.id).sum(:shipping),
      taxes:  OrderLine.where('orderid = ?', self.id).sum(:taxes),
      codcharges: OrderLine.where('orderid = ?', self.id).sum(:codcharges),
      total: OrderLine.where('orderid = ?', self.id).sum(:total))
  end

  def on_update
    self.update(pieces: OrderLine.where('orderid = ?', self.id).sum(:pieces),
     subtotal: OrderLine.where('orderid = ?', self.id).sum(:subtotal),
     shipping: OrderLine.where('orderid = ?', self.id).sum(:shipping),
      taxes:  OrderLine.where('orderid = ?', self.id).sum(:taxes),
      codcharges: OrderLine.where('orderid = ?', self.id).sum(:codcharges),
      total: OrderLine.where('orderid = ?', self.id).sum(:total))

  end

  def on_destroy
    self.update(pieces: OrderLine.where('orderid = ?', self.id).sum(:pieces),
     subtotal: OrderLine.where('orderid = ?', self.id).sum(:subtotal),
     shipping: OrderLine.where('orderid = ?', self.id).sum(:shipping),
      taxes:  OrderLine.where('orderid = ?', self.id).sum(:taxes),
      codcharges: OrderLine.where('orderid = ?', self.id).sum(:codcharges),
      total: OrderLine.where('orderid = ?', self.id).sum(:total))
      #self.update_column(pieces: 0,subtotal: 0, taxes: 0, codcharges: 0, shipping:0, total: 0)
  end

  def parse_uri url
        url = URI.parse(encoded_url)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        request = Net::HTTP::Post.new(url)
        request["authorization"] = 'pae1W74vWnCezNDi1oiZ3HJyL7FgzxqfhuTWX5XljYA='
        response = http.request(request)

        get_response = JSON.parse(response.read_body)
        return get_response
  end

  def parse_check_paid_uri url
        url = URI.parse(encoded_url)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        request = Net::HTTP::Post.new(url)
        #request["authorization"] = 'pae1W74vWnCezNDi1oiZ3HJyL7FgzxqfhuTWX5XljYA='
        response = http.request(request)

        get_response = JSON.parse(response.read_body)
        return get_response
  end

end
