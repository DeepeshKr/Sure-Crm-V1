module TransferOrders
	def check_transfer(order_id)

		order = OrderMaster.where(external_order_no: order_id)
		order_details = OrderLines.joins(:order_master).where("order_masters.external_order_no = ?", order_id)
		order_pin = order.first.pincode
		order_total = order.first.g_total
		product_list = order_details.pluck(:product_list_id)

		#valid pincode
		dis_pin = DistributorPincodeList.where(pincode: order_pin).joins(:corporate).where("corporates.active = ? ", 10002)
		corporate_id = dis_pin.first.corporate_id
		#check if order from valid pincode
		if dis_pin.blank?
			#create vpp order
			create_vpp(order_id)
			return 0
		end
			#check if dealer mis balance more than order value
		if dis_pin.corporate.rupee_balance == 0 || dis_pin.corporate.rupee_balance.blank?
			#create dealer trail for less mis balance
			missed_order(order_id, 10000, corporate_id, order_total, "This order was missed on account of low MIS balance")

			#create vpp order
			create_vpp(order_id)
			return 0
		end
		total_products_sold = order.first.pieces
		total_product_found = 0

		#check all the products in the list
		order_details.each do | line|
			corporate_stock_list = DistributorStockBooks.where(product_list_id: line.product_list_id).where("closing_qty > 0")
			if corporate_stock_list.present?
				total_product_found += 1
			end
		end

		
		if total_products_sold != total_product_found
			#create dealer trail for less mis balance
			missed_order(order_id, 10001, corporate_id, order_total, "total product required #{total_products_sold} where we only have #{total_product_found} with the dealer")

			#create vpp order
			create_vpp(order_id)
			return 0
		end
		
		#create dealer order
		#check all the products in the list
		order_details.each do | line|
			corporate_stock_list = DistributorStockBooks.where(product_list_id: line.product_list_id).where("closing_qty > 0")
			if corporate_stock_list.present?
				dealer_stock(order_id, product_list_id)
				create_dealer_order(order_id)
			end
		end
		
			
	end 

	
	def create_vpp(order_id)
		#Direct Order 10002
		pro_order_master = OrderMaster.where(external_order_no: order_id)
		pro_order_master.first!

		order_lines = OrderLine.where(orderid: pro_order_master.id)

		order_lines.each do | order_line |


		end

	end


	def create_dealer_order(order_id, corporate_code, corporate_name)
		#Distributor Order 	10001
		 t = Time.zone.now + 330.minutes
          nowhour = t.strftime('%H').to_i
          #=> returns a 0-padded string of the hour, like "07"
          nowminute = t.strftime('%M').to_i

		vpp_deal_tran = VppDealTran.create(
			actdate: (330.minutes).from_now.to_date,
			action:          ,
			add1: pro_order_master.customer_address.address1[0..29].upcase, 
          	add2: pro_order_master.customer_address.address2[0..29].upcase, 
          	add3: (pro_order_master.customer_address.address3[0..29].upcase if pro_order_master.customer_address.address3.present?),
			barcode: ,
			barcode2: ,
			barcode3: ,
			basicprice:  order_line.subtotal,
			cfo: ,
			channel: pro_order_master.medium.name.strip[0..48].upcase, 
			city: pro_order_master.customer_address.city[0..29].upcase,
			claimdate:          ,
			codamt: order_line.codcharges,
			convcharges:  order_line.codcharges,
			cou:,
			custref:  , #external order id        ,
			debitnote: ,
			debitnotedate: ,
			delvdate:,
			deo: pro_order_master.employeecode,
			dept:      #TOTDAIRTEL    ,
			despatch: 'EPP',
			dist: 'Y',
			distcode:   corporate_code,
			distname:   corporate_name,
			dt_hour: nowhour,
          	dt_min: nowminute,
			email: (pro_order_master.customer.emailid[0..19].upcase if pro_order_master.customer.emailid.present?), 
         	emi: ,
			entrydate:  t,
			fax: (pro_order_master.customer_address.fax[0..19].upcase if pro_order_master.customer_address.fax.present?), 
			fname: pro_order_master.customer.first_name[0..29].upcase, 
			invdate: ,
			fsize: ,
			invoice: ,
			invoiceamount:  pro_order_master.g_total, #pro_order_master.subtotal + pro_order_master.shipping + pro_order_master.codcharges + pro_order_master.servicetax + pro_order_master.maharastracodextra
			landmark: pro_order_master.customer_address.landmark[0..49].upcase, 
			letter: ,
			lessprod: ,
			lname: pro_order_master.customer.last_name[0..29].upcase, 
			loydate:  ,
			manifest: ,
			modby: ,
			moddt: ,
			notice: ,
			normal: ,
			operator: (pro_order_master.employee.name[0..49].upcase || current_user.name.truncate(50).upcase if pro_order_master.employee.present?),
			order_number:,
			orderdate:      #    ,
			orderno:pro_order_master.external_order_no,
			ordersource:'T',
			paidamt: ,
			paiddate: ,
			ordertype: ,
			pin:pro_order_master.customer_address.pincode, 
			postage: order_line.shipping,
			probag:          ,
			prod: order_line.product_list.extproductcode,
			qty: 1 ,
			remarks:          ,
			refundamt:          ,
			refundcheck:          ,
			refundcheckdate:          ,
			refunddate:          ,
			returndate:          ,
			sanction:          ,
			shdate:          ,
			shipped:          ,
			state: pro_order_master.customer_address.st[0..4].upcase, 
			status:          ,
			statusdate:          ,
			taxamt:          ,
			taxper:          ,
			tel1: pro_order_master.customer.mobile[0..19].upcase, 
          	tel2: (pro_order_master.customer_address.telephone2[0..17].upcase if pro_order_master.customer_address.telephone2.present?),
			tempstatus:          ,
			tempstatusdate:          ,
			temptrandate:          ,
			title: pro_order_master.customer.salute[0..4].upcase, 
			trandate: t,
			transfer:'N',
			trantype:          ,
			vpp: 1,
			weight: order_line.product_master.weight_kg ,
			invoicerefno: order_line.id,
			description:          ,
			order_last_mile_id:          ,
			order_final_status_id:          )



	end

	def dealer_stock(order_id, corporate_id, product_list_id)
		product_list = ProductList.find(product_list_id)
		t = Time.zone.now + 330.minutes
		DistributorStockLedger.create(corporate_id: corporate_id,
			product_master_id: product_list,
			product_variant_id: ,
			product_list_id: product_list_id,
			prod: ,
			name: "Sale of Goods",
			description: "Customer order no #{order_id}",
			stock_change: -1,
			stock_value: 0,
			ledger_date: t,
			type_id: 10002)


	end
	#Remove stock as sold to customer, id 10002
	#DistributorStockLedger.new(distributor_stock_ledger_params)
	# params.require(:distributor_stock_ledger).permit(:corporate_id, 
	#         :product_master_id, 
	#         :product_variant_id, 
	#         :product_list_id, :prod, :name, 
	#         :description, :stock_change, :stock_value, :ledger_date,
	#         :type_id)

	def missed_order(order_id, missed_type_id, corporate_id, order_total, description)
		#MIS balance low = 10000
		#No Product Stock = 10001

		 # case missed_type_id # a_variable is the variable we want to compare
   #        when 10000
   #        	description = "This order was missed on account of low MIS balance"
   #        when 10001
   #        	description = "This order was missed on account of low or no stock"
   #        else
   #        	description = "This order was missed with no reasons"
   #        end

		distributormissedorder = DistributorMissedOrder.create(corporate_id: corporate_id,
			missed_type_id: missed_type_id,
			order_value: order_total,
			order_id: order_id,
			description: description)

		#     params.require(:distributor_missed_order).permit(:corporate_id, :missed_type_id, 
			#:order_value, :order_no, :order_id, :description)

	end


end