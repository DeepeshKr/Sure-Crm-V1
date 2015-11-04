module CustomerOrder

	 def update_customer_order_list(order_id)
      creditcardno =  nil
      expmonth = nil
      expyear = nil
      name_on_card = nil
      cardname = nil
      
      #order_id = @order_master.id
      pro_order_master = OrderMaster.find(order_id)

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
          totalamt: pro_order_master.subtotal + pro_order_master.shipping + pro_order_master.codcharges + pro_order_master.servicetax + pro_order_master.maharastracodextra ,
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
          totalamt: pro_order_master.subtotal + pro_order_master.shipping + pro_order_master.codcharges + pro_order_master.servicetax + pro_order_master.maharastracodextra ,
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

end