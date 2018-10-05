class TransDetails < ActiveRecord::Base
	if Rails.env == "development"
		establish_connection :development_sql_tpl_mall
	elsif Rails.env == "production"
		establish_connection :production_sql_tpl_mall
	end
  
	self.table_name = 'TransDetails'
 	alias_attribute :tid, :Tid
 	alias_attribute :order_date, :OrderDate
	alias_attribute :order_no, :OrderNo
	alias_attribute :channel, :Channel
	alias_attribute :product, :Product
	alias_attribute :amount, :Amount
	alias_attribute :shipped, :Shipped
	alias_attribute :paid, :Paid
	alias_attribute :return, :Return
	alias_attribute :refund, :Refund
	alias_attribute :customer_name, :CustomerName
	alias_attribute :city, :City
	alias_attribute :comm, :Comm
    
  def online_records calledno, from_date, to_date
      order_masters_order_nos = OrderMaster.where(calledno: calledno)
          .where('TRUNC(orderdate) >= ? and TRUNC(orderdate) <= ?', from_date, to_date)
          .where('ORDER_STATUS_MASTER_ID > 10000')
          .order("orderdate DESC")
          .limit(100).pluck(:external_order_no)
          
      trans_details =  TransDetails.where(order_no: order_masters_order_nos).limit(100)
      
    end
     
  def order_ref_id
      cable_operator = CableOperatorComm.where(transdetails_id: self.tid)
      
      return nil if cable_operator.blank?
      
      return cable_operator.first.order_id
    end
    
  def create_update_customer_unpaid_order_list(order_id)
  transdetails_id = nil
  order_master = OrderMaster.find(order_id)
  #external_order_no: external_order_no
  #order_id = order_master.id
  if order_master.medium.media_group_id != 10000
    return puts "Skipped order id #{order_id} from #{order_master.medium.name} it is not HBN Channel! "
  end  

  t = Time.zone.now + 330.minutes
      nowhour = t.strftime('%H').to_i
      #=> returns a 0-padded string of the hour, like "07"
      nowminute = t.strftime('%M').to_i
      nowtoday = Date.today.in_time_zone.strftime('%d/%m/%y')


     qty1 = ""
     qty2 = ""
     qty3 = ""
     qty4 = ""
     qty5 = ""
     qty6 = ""
     qty7 = ""
     qty8 = ""
     qty9 = ""

     prod1 = ""
     prod2 = ""
     prod3 = ""
     prod4 = ""
     prod5 = ""
     prod6 = ""
     prod7 = ""
     prod8 = ""
     prod9 = ""
    
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
     
      # allproducts = prod1 + " (" + qty1 +") + " + prod2 + " (" + qty2  +") " +
      #  prod3 + " (" + qty3  +") " +  prod4 + " (" + qty4  +") " +
      #  prod5 + " (" + qty5  +") " +  prod6 + " (" + qty6  +") " +
      #  prod7 + " (" + qty7  +") " +  prod8 + " (" + qty8  +") " +
      #  prod9 + " (" + qty9  +") "

      allproducts = "#{prod1} #{prod2} #{prod3} #{prod4} #{prod5} #{prod6} #{prod7} #{prod8} #{prod9}"
  
      # prod1 + " " + prod2 + " " +
      # prod3 + " " +  prod4 + " " +
      # prod5 + " " +  prod6 + " " +
      # prod7 + " " +  prod8 + " " +
      # prod9
          
      amount = 0.0
      reverse_vat_rate = 0.0
      commission = 0.0
    if order_master.subtotal.present?
      #get Reverse VAT Rate
      reverse_vat_rate = TaxRate.find(10001)
      if reverse_vat_rate.present?

        amount  = order_master.subtotal * reverse_vat_rate.reverse_rate
        amount = amount.round(2)
      end

      if Medium.where(id: order_master.media_id).present?
        medialist = Medium.find(order_master.media_id)
        if medialist.value.present?
          commission =  amount * medialist.value
          commission =  commission.round(2)
        end
      end
      # .permit(:tid, :order_date, :order_no, :channel,
      # 	:product, :amount, :shipped, :paid, :return,
      # 	:refund, :customer_name, :city, :comm)
    end

		media_id = order_master.media_id || nil if order_master.medium
		media_id = order_master.media_id
		dnis = order_master.calledno
		city = order_master.customer_address.city
		state = order_master.customer_address.state
          
    #check for the tid from CableOperatorComm
    cable_operator = CableOperatorComm.where(order_id: order_id).where("transdetails_id IS NOT NULL")
    if cable_operator.present?
     transdetails_id = cable_operator.first.transdetails_id
    end
          
    #check if orderno is tran detail id already updated
    if !transdetails_id.present?
     channel = (order_master.medium.name.strip[0..48].upcase if order_master.medium.present?)[0...-1]
   
     transdetail = TransDetails.create(order_date: (order_master.orderdate + 330.minutes).to_date,
      channel: channel,
      product: allproducts,
      amount: amount,
      customer_name: (order_master.customer.upper_full_name if order_master.customer.present?),
      city: (order_master.customer_address.city[0..29].upcase if order_master.customer_address.present?),
      comm: commission)
    
      transdetails_id = transdetail.tid

        puts "Created NEW on hbn.telebrandsindia.com => channel #{channel} #{media_id} for dnis #{dnis} from #{city} in #{state} order dated #{(order_master.orderdate + 330.minutes).to_date} order no #{order_master.external_order_no} Gross Rs #{order_master.subtotal} Net Rs #{amount} Comm #{commission} "

    else
      channel = (order_master.medium.name.strip[0..48].upcase if order_master.medium.present?)[0...-1]

      transdetail = TransDetails.where(tid: transdetails_id).first
      transdetail.update(order_date: (order_master.orderdate + 330.minutes).to_date,
      channel: channel,
      product: allproducts,
      amount: amount,
      customer_name: (order_master.customer.upper_full_name if order_master.customer.present?),
      city: (order_master.customer_address.city[0..29].upcase if order_master.customer_address.present?),
      comm: commission)
    
      transdetails_id = transdetail.tid
			cable_operator_comms = CableOperatorComm.where(order_id: order_id)

			media_id = order_master.media_id || nil if order_master.medium

      dnis = order_master.calledno
      city = order_master.customer_address.city
      state = order_master.customer_address.state
      media_id = order_master.media_id
    
      puts "Already Found details online hbn.telebrandsindia.com. Now again updated transdetails channel #{channel} #{media_id} for dnis #{dnis} from #{city} in #{state} order dated #{(order_master.orderdate + 330.minutes).to_date} order no #{order_master.external_order_no} Gross Rs #{order_master.subtotal} Net Rs #{amount} Comm #{commission}  
      Channel: #{transdetail.channel} 
      customer: #{transdetail.customer_name}
      amount: #{transdetail.amount}
      Commission: #{transdetail.comm}
      product: #{transdetail.product} 
      city: #{transdetail.city}"
    
    end

	  cable_operator_comms = CableOperatorComm.where(order_id: order_id)

		if cable_operator_comms.present?
			cable_operator_comm = cable_operator_comms.first

			cable_operator_comm.update(order_date: (order_master.orderdate + 330.minutes).to_date,
      transdetails_id: transdetails_id,
			order_id: order_master.id,
			media_id: order_master.media_id,
			channel: channel,
			product: allproducts,
			amount: amount,
			customer_name: order_master.customer.upper_full_name,
			city: order_master.customer_address.city[0..29].upcase,
			comm: commission,
			description: "Updated unpaid order for channel #{channel} #{media_id} for dnis #{dnis} from #{city} in #{state} order dated #{(order_master.orderdate + 330.minutes).to_date} order no #{order_master.external_order_no} Gross Rs #{order_master.subtotal} Net Rs #{amount} Comm #{commission} ")

			puts "Updated order for channel #{channel} #{media_id} for dnis #{dnis} from #{city} in #{state} order dated #{(order_master.orderdate + 330.minutes).to_date} order no #{order_master.external_order_no} Gross Rs #{order_master.subtotal} Net Rs #{amount} Comm #{commission} "

		else
			CableOperatorComm.create(transdetails_id: transdetails_id,
			order_date: (order_master.orderdate + 330.minutes).to_date,
			order_id: order_master.id,
			media_id: media_id,
			channel: channel,
			product: allproducts,
			amount: amount,
			customer_name: order_master.customer.upper_full_name,
			city: order_master.customer_address.city[0..29].upcase,
			comm: commission,
			description: "Created unpaid order for channel #{channel} #{media_id} for dnis #{dnis} from #{city} in #{state} order dated #{(order_master.orderdate + 330.minutes).to_date} order no #{order_master.external_order_no} Gross Rs #{order_master.subtotal} Net Rs #{amount} Comm #{commission} ")

			puts "Created order for channel #{channel} #{media_id} for dnis #{dnis} from #{city} in #{state} order dated #{(order_master.orderdate + 330.minutes).to_date} order no #{order_master.external_order_no} Gross Rs #{order_master.subtotal} Net Rs #{amount} Comm #{commission} "
		end


  end
  
  def update_customer_order_list(order_id)

      order_master = OrderMaster.find(order_id)
      #external_order_no: external_order_no
      #order_id = order_master.id
      external_order_no = order_master.external_order_no
      t = Time.zone.now + 330.minutes
          nowhour = t.strftime('%H').to_i
          #=> returns a 0-padded string of the hour, like "07"
          nowminute = t.strftime('%M').to_i
          nowtoday = Date.today.in_time_zone.strftime('%d/%m/%y')

     if !OrderUpdate.where(orderno: order_master.external_order_no).present?
      #create orderupdate
      OrderUpdate.create(order_id: order_master.id,
        orderno: order_master.external_order_no,
        order_value: order_master.total,
        order_date: (order_master.orderdate + 330.minutes).to_date)
     else
      #update order_update
      order_update = OrderUpdate.where(orderno: order_master.external_order_no).first
      order_update.update(order_id: order_master.id,
           order_value: order_master.total,
        order_date: (order_master.orderdate + 330.minutes).to_date)

     end

    if order_master.medium.media_group_id != 10000
      return puts "Skipped order number #{external_order_no} from #{order_master.medium.name} it is not HBN Channel! "
    end

    if order_master.external_order_no.present?
         qty1 = ""
         qty2 = ""
         qty3 = ""
         qty4 = ""
         qty5 = ""
         qty6 = ""
         qty7 = ""
         qty8 = ""
         qty9 = ""

         prod1 = ""
         prod2 = ""
         prod3 = ""
         prod4 = ""
         prod5 = ""
         prod6 = ""
         prod7 = ""
         prod8 = ""
         prod9 = ""
          
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
           
          # allproducts = prod1 + " (" + qty1 +") + " + prod2 + " (" + qty2  +") " +
          #  prod3 + " (" + qty3  +") " +  prod4 + " (" + qty4  +") " +
          #  prod5 + " (" + qty5  +") " +  prod6 + " (" + qty6  +") " +
          #  prod7 + " (" + qty7  +") " +  prod8 + " (" + qty8  +") " +
          #  prod9 + " (" + qty9  +") "

          allproducts = "#{prod1} #{prod2} #{prod3} #{prod4} #{prod5} #{prod6} #{prod7} #{prod8} #{prod9}"
      
          # prod1 + " " + prod2 + " " +
          # prod3 + " " +  prod4 + " " +
          # prod5 + " " +  prod6 + " " +
          # prod7 + " " +  prod8 + " " +
          # prod9
        
            amount = 0.0
            reverse_vat_rate = 0.0
            commission = 0.0
          if order_master.subtotal.present?
            #get Reverse VAT Rate
            reverse_vat_rate = TaxRate.find(10001)
            if reverse_vat_rate.present?

              amount  = order_master.subtotal * reverse_vat_rate.reverse_rate
              amount = amount.round(2)
            end

            if Medium.where(id: order_master.media_id).present?
              medialist = Medium.find(order_master.media_id)
              if medialist.value.present?
                commission =  amount * medialist.value
                commission =  commission.round(2)
              end
            end
            # .permit(:tid, :order_date, :order_no, :channel,
            # 	:product, :amount, :shipped, :paid, :return,
            # 	:refund, :customer_name, :city, :comm)
          end

					media_id = order_master.media_id || nil if order_master.medium
					media_id = order_master.media_id
					dnis = order_master.calledno
					city = order_master.customer_address.city
					state = order_master.customer_address.state

          #check for the tid from CableOperatorComm
          cable_operator = CableOperatorComm.where(order_id: order_id).where("transdetails_id IS NOT NULL")
          if cable_operator.present?
           transdetails_id = cable_operator.first.transdetails_id
          end
          order_no = order_master.external_order_no || nil if order_master.external_order_no.present?
          #check if orderno is tran detail id already updated
          if !transdetails_id.present?
           channel = (order_master.medium.name.strip[0..48].upcase if order_master.medium.present?)[0...-1]

            transdetail = TransDetails.create(order_no: order_no,
            order_date: (order_master.orderdate + 330.minutes).to_date,
            channel: channel,
            product: allproducts,
            amount: amount,
            customer_name: order_master.customer.salute[0..4].upcase + " " + order_master.customer.first_name[0..29].upcase + " " + order_master.customer.last_name[0..29].upcase,
            city: order_master.customer_address.city[0..29].upcase,
            comm: commission)

              puts "Created NEW on hbn.telebrandsindia.com => 
              channel #{channel} #{media_id} for dnis #{dnis} from #{city} in #{state} 
              order dated #{(order_master.orderdate + 330.minutes).to_date} 
              order no #{order_master.external_order_no} 
              Gross Rs #{order_master.subtotal} Net Rs #{amount} Comm #{commission} "

          else
            channel = (order_master.medium.name.strip[0..48].upcase if order_master.medium.present?)[0...-1]

            transdetail = TransDetails.where(tid: transdetails_id).first
           
            transdetail.update(order_date: (order_master.orderdate + 330.minutes).to_date,
            order_no: order_no,
            channel: channel,
            product: allproducts,
            amount: amount,
            customer_name: order_master.customer.salute[0..4].upcase + " " + order_master.customer.first_name[0..29].upcase + " " + order_master.customer.last_name[0..29].upcase,
            city: order_master.customer_address.city[0..29].upcase,
            comm: commission)

						cable_operator_comms = CableOperatorComm.where(order_id: order_id)

						media_id = order_master.media_id || nil if order_master.medium

            dnis = order_master.calledno
            city = order_master.customer_address.city
            state = order_master.customer_address.state
            media_id = order_master.media_id
            
            puts "Already Found details online hbn.telebrandsindia.com. Now again updated transdetails 
            channel #{channel} #{media_id} for dnis #{dnis} from #{city} in #{state} 
            order dated #{(order_master.orderdate + 330.minutes).to_date} 
            order no #{order_master.external_order_no} 
            Gross Rs #{order_master.subtotal} Net Rs #{amount} Comm #{commission}  
            Channel: #{transdetail.channel} 
            customer: #{transdetail.customer_name}
            amount: #{transdetail.amount}
            Commission: #{transdetail.comm}
            product: #{transdetail.product} 
            city: #{transdetail.city}"
            
          end

					cable_operator_comms = CableOperatorComm.where(order_id: order_id)

					if cable_operator_comms.present?
						cable_operator_comm = cable_operator_comms.first

						cable_operator_comm.update(order_no: order_no,
            transdetails_id: transdetails_id,
						order_date: (order_master.orderdate + 330.minutes).to_date,
						order_id: order_master.id,
						media_id: order_master.media_id,
						channel: channel,
						product: allproducts,
						amount: amount,
						customer_name: order_master.customer.salute[0..4].upcase + " " + order_master.customer.first_name[0..29].upcase + " " + order_master.customer.last_name[0..29].upcase,
						city: order_master.customer_address.city[0..29].upcase,
						comm: commission,
						description: "Updated for channel #{channel} #{media_id} for dnis #{dnis} from #{city} in #{state} order dated #{(order_master.orderdate + 330.minutes).to_date} order no #{order_master.external_order_no} Gross Rs #{order_master.subtotal} Net Rs #{amount} Comm #{commission} ")

						puts "Updated order for channel #{channel} #{media_id} for dnis #{dnis} from #{city} in #{state} order dated #{(order_master.orderdate + 330.minutes).to_date} order no #{order_master.external_order_no} Gross Rs #{order_master.subtotal} Net Rs #{amount} Comm #{commission} "

					else
						CableOperatorComm.create(order_no: order_no,
						order_date: (order_master.orderdate + 330.minutes).to_date,
             transdetails_id: transdetails_id,
						order_id: order_master.id,
						media_id: media_id,
						channel: channel,
						product: allproducts,
						amount: amount,
						customer_name: order_master.customer.salute[0..4].upcase + " " + order_master.customer.first_name[0..29].upcase + " " + order_master.customer.last_name[0..29].upcase,
						city: order_master.customer_address.city[0..29].upcase,
						comm: commission,
						description: "Created order for channel #{channel} #{media_id} for dnis #{dnis} from #{city} in #{state} order dated #{(order_master.orderdate + 330.minutes).to_date} order no #{order_master.external_order_no} Gross Rs #{order_master.subtotal} Net Rs #{amount} Comm #{commission} ")

						puts "Created order for channel #{channel} #{media_id} for dnis #{dnis} from #{city} in #{state} order dated #{(order_master.orderdate + 330.minutes).to_date} order no #{order_master.external_order_no} Gross Rs #{order_master.subtotal} Net Rs #{amount} Comm #{commission} "
					end

          #- Integer update with customer order id
      end


  end

end
 