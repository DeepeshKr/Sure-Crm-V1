module TransferOrders
	def check_transfer(order_id)

		order = OrderMaster.where(external_order_no: order_id)
		#order_status_master_id: 10003
		return "The order details not available!" if !order.present?

		return "The order is not processed!" if order.first.order_status_master_id <= 10002

		return "The order is not COD order, only COD orders are processed by distributor!" if order.first.orderpaymentmode_id != 10001


		order_details = OrderLine.joins(:order_master).where("order_masters.external_order_no = ?", order_id)
		order_pin = order.first.pincode
		order_total = order.first.g_total
		product_list = order_details.pluck(:product_list_id)



		#valid pincode
		dis_pin = DistributorPincodeList.where(pincode: order_pin).joins(:corporate).where("corporates.active = ? ", 10002)
		corporate_id = dis_pin.first.corporate_id || 0 if dis_pin.present?
		#check if order from valid pincode
		if dis_pin.blank?
			#create vpp order
			#create_vpp(order_id)
			return "The pincode #{order_pin} is not serviced by any distributor"
		end
			#check if dealer mis balance more than order value
		if (dis_pin.corporate.rupee_balance == 0) || (dis_pin.corporate.rupee_balance.blank?) || (dis_pin.corporate.rupee_balance < order_total)
			#create dealer trail for less mis balance
			missed_order(order_id, 10000, corporate_id, order_total, "This order was missed on account of low MIS balance")

			#create vpp order
			#create_vpp(order_id)
			return "The distributor balance is low #{rupee_balance.to_s} as compared to order total #{order_total}"
		end
		total_products_sold = order.first.pieces
		total_product_found = 0

		#city customer_address_id
		#customer_address.state
		customer_address = CustomerAddress.find(order.customer_address_id)
		#get state
		state = customer_address.state

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

			#this is retail vpp order ignore it
			#create_vpp(order_id)
			return "The order has #{total_products_sold.to_s} products while distributor has stock for #{total_product_found.to_s}"
		end

		#create dealer order
		#check all the products in the list
		order_details.each do | line|
			corporate_stock_list = DistributorStockBooks.where(product_list_id: line.product_list_id).where("closing_qty > 0")
			if corporate_stock_list.present?
				dealer_stock(order_id, product_list_id, state)
				create_dealer_order(order_id)
			end
		end

		#update cust details with 1
		custdetails = CUSTDETAILS.where(order_num: order_id).first

		#update transfer order with this information to
		#ensure that orders are not transffered to VPP
		#custdetails.update(transfer_ok: 1)
		custdetails.update(transfer_ok: 0)
		return "Created customer order, skipped all parameters for Distributor Order"
	end


	def create_vpp(order_id)
		#Direct Order 10002
		# pro_order_master = OrderMaster.where(external_order_no: order_id)
		# pro_order_master.first!

		# order_lines = OrderLine.where(orderid: pro_order_master.id)

		# order_lines.each do | order_line |
		#end

	end


	def create_dealer_order(order_id, corporate_code, corporate_name)
		#Distributor Order 	10001
		 t = Time.zone.now + 330.minutes
          nowhour = t.strftime('%H').to_i
          #=> returns a 0-padded string of the hour, like "07"
          nowminute = t.strftime('%M').to_i
          pro_order_master = OrderMaster.where(external_order_no: order_id)
		pro_order_master = pro_order_master.first

		order_lines = OrderLine.where(orderid: pro_order_master.id)

		order_lines.each do | order_line |

		vpp_deal_tran = VppDealTran.create(
			actdate: t,
			add1: pro_order_master.customer_address.address1[0..29].upcase,
          	add2: pro_order_master.customer_address.address2[0..29].upcase,
          	add3: (pro_order_master.customer_address.address3[0..29].upcase if pro_order_master.customer_address.address3.present?),
			basicprice:  order_line.subtotal,
			channel: pro_order_master.medium.name.strip[0..48].upcase,
			city: pro_order_master.customer_address.city[0..29].upcase,
			codamt: order_line.codcharges,
			convcharges:  order_line.codcharges,
			custref:  order_id, #external order id        ,
			deo: pro_order_master.employeecode,
			despatch: 'EPP',
			dist: 'Y',
			distcode:   corporate_code,
			distname:   corporate_name,
			dt_hour: nowhour,
          	dt_min: nowminute,
			email: (pro_order_master.customer.emailid[0..19].upcase if pro_order_master.customer.emailid.present?),
         	entrydate:  t,
			fax: (pro_order_master.customer_address.fax[0..19].upcase if pro_order_master.customer_address.fax.present?),
			fname: pro_order_master.customer.first_name[0..29].upcase,
			invoiceamount:  pro_order_master.g_total, #pro_order_master.subtotal + pro_order_master.shipping + pro_order_master.codcharges + pro_order_master.servicetax + pro_order_master.maharastracodextra
			landmark: pro_order_master.customer_address.landmark[0..49].upcase,
			lname: pro_order_master.customer.last_name[0..29].upcase,
			operator: (pro_order_master.employee.name[0..49].upcase || current_user.name.truncate(50).upcase if pro_order_master.employee.present?),
			orderdate:   pro_order_master.order_date,
			orderno:pro_order_master.external_order_no,
			ordersource:'T', #'P' 'I'
			pin:pro_order_master.customer_address.pincode,
			postage: order_line.shipping,
			prod: order_line.product_list.extproductcode,
			qty: order_line.pieces ,
			state: pro_order_master.customer_address.st[0..4].upcase,
			tel1: pro_order_master.customer.mobile[0..19].upcase,
          	tel2: (pro_order_master.customer_address.telephone2[0..17].upcase if pro_order_master.customer_address.telephone2.present?),
			title: pro_order_master.customer.salute[0..4].upcase,
			trandate: t,
			transfer:'N',
			vpp: 1,
			weight: order_line.product_master.weight_kg ,
			invoicerefno: order_line.id,
			description: "Order under process by distributor",
			order_last_mile_id: 10001,
			order_final_status_id:10001)

		end

	end

	def dealer_stock(order_id, corporate_id, product_list_id, state)


		product_list = ProductList.find(product_list_id)
		productcode = product_list.extproductcode
		transferorderpricing = wholesale_price(productcode, state)
		t = Time.zone.now + 330.minutes
		DistributorStockLedger.create(corporate_id: corporate_id,
			product_master_id: product_list.product_master_id,
			product_variant_id: product_list.product_variant_id,
			product_list_id: product_list_id,
			prod: product_list.extproductcode,
			name: "Sale of Goods",
			description: "Customer order no #{order_id}",
			stock_change: -1,
			stock_value: transferorderpricing.final_total,
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

			# vpp_deal_tran = VppDealTran.create(
			# actdate: t,
			# action: ,
			# add1: pro_order_master.customer_address.address1[0..29].upcase,
   #        	add2: pro_order_master.customer_address.address2[0..29].upcase,
   #        	add3: (pro_order_master.customer_address.address3[0..29].upcase if pro_order_master.customer_address.address3.present?),
			# barcode: ,
			# barcode2: ,
			# barcode3: ,
			# basicprice:  order_line.subtotal,
			# cfo: ,
			# channel: pro_order_master.medium.name.strip[0..48].upcase,
			# city: pro_order_master.customer_address.city[0..29].upcase,
			# claimdate: ,
			# codamt: order_line.codcharges,
			# convcharges:  order_line.codcharges,
			# cou:,
			# custref:  order_id, #external order id        ,
			# debitnote: ,
			# debitnotedate: ,
			# delvdate:,
			# deo: pro_order_master.employeecode,
			# dept:      #TOTDAIRTEL naushad enters  no need for transfer order  ,
			# despatch: 'EPP',
			# dist: 'Y',
			# distcode:   corporate_code,
			# distname:   corporate_name,
			# dt_hour: nowhour,
   #        	dt_min: nowminute,
			# email: (pro_order_master.customer.emailid[0..19].upcase if pro_order_master.customer.emailid.present?),
   #       	emi: ,
			# entrydate:  t,
			# fax: (pro_order_master.customer_address.fax[0..19].upcase if pro_order_master.customer_address.fax.present?),
			# fname: pro_order_master.customer.first_name[0..29].upcase,
			# invdate: ,
			# fsize: ,
			# invoice: ,
			# invoiceamount:  pro_order_master.g_total, #pro_order_master.subtotal + pro_order_master.shipping + pro_order_master.codcharges + pro_order_master.servicetax + pro_order_master.maharastracodextra
			# landmark: pro_order_master.customer_address.landmark[0..49].upcase,
			# letter: ,
			# lessprod: ,
			# lname: pro_order_master.customer.last_name[0..29].upcase,
			# loydate:  ,
			# manifest: ,
			# modby: ,
			# moddt: ,
			# notice: ,
			# normal: ,
			# operator: (pro_order_master.employee.name[0..49].upcase || current_user.name.truncate(50).upcase if pro_order_master.employee.present?),
			# order_number:,
			# orderdate:   pro_order_master.order_date    ,
			# orderno:pro_order_master.external_order_no,
			# ordersource:'T', #'P' 'I'
			# paidamt: ,
			# paiddate: ,
			# ordertype: ,
			# pin:pro_order_master.customer_address.pincode,
			# postage: order_line.shipping,
			# probag:          ,
			# prod: order_line.product_list.extproductcode,
			# qty: order_line.pieces ,
			# remarks: ,
			# refundamt:  ,
			# refundcheck:  ,
			# refundcheckdate:  ,
			# refunddate: ,
			# returndate: ,
			# sanction: ,
			# shdate: ,
			# shipped: ,
			# state: pro_order_master.customer_address.st[0..4].upcase,
			# status: ,
			# statusdate: ,
			# taxamt: ,
			# taxper:  ,
			# tel1: pro_order_master.customer.mobile[0..19].upcase,
   #        	tel2: (pro_order_master.customer_address.telephone2[0..17].upcase if pro_order_master.customer_address.telephone2.present?),
			# tempstatus: ,
			# tempstatusdate: ,
			# temptrandate:,
			# title: pro_order_master.customer.salute[0..4].upcase,
			# trandate: t,
			# transfer:'N',
			# trantype: ,
			# vpp: 1,
			# weight: order_line.product_master.weight_kg ,
			# invoicerefno: order_line.id,
			# description: "Order under process by distributor",
			# order_last_mile_id: 10001,
			# order_final_status_id:10001)

			def wholesale_price(product_code, state)
				transfer_order_pricing = TransferOrderPricing.new
				productlists = ProductList.where(extproductcode: product_code)

				productlist = productlists.first
				transfer_order_pricing.full_product_name = productlist.productname
				transfer_order_pricing.product_code
				transfer_order_pricing.state
				taxrates = TaxRate.where(name: state)
				transfer_order_pricing.vat_percent = 0.125
				transfer_order_pricing.reverse_rate = 0.88888889

				transfer_order_pricing.basic = productlist.product_variant.price
				transfer_order_pricing.shipping= productlist.product_variant.shipping

				transfer_order_pricing.for_state = state

				if taxrates.present?
					transfer_order_pricing.vat_percent = taxrates.first.taxrate
					transfer_order_pricing.reverse_rate = taxrates.first.reverse_rate
				end

				# Step 1 Get Landed Price
				# e.g for Product CHEF DINI CHE 999 + 395 + 1394 + 70 = 1464
				# COD 5% or 0.05
				transfer_order_pricing.cod = (transfer_order_pricing.basic + transfer_order_pricing.shipping) * 0.05
				transfer_order_pricing.total_product_price = (transfer_order_pricing.basic ||= 0) + (transfer_order_pricing.shipping ||= 0 ) + (transfer_order_pricing.cod ||= 0)
				# Step 2 if state not MH remove taxes (TAX REFUNDABLE)
				# Reduce VAT from Basic e.g. Rest 0.8810572687 / MH 0.88888889
				# basic now becomes 878	888
				# add shipping + cod charge 878 + 395 + 70 === 888 + 395 + 70

				transfer_order_pricing.basic_price = transfer_order_pricing.basic * transfer_order_pricing.reverse_rate

			transfer_order_pricing.landed_price = (transfer_order_pricing.basic_price ||= 0) + (transfer_order_pricing.shipping ||= 0 ) + (transfer_order_pricing.cod ||= 0)
				# Step 3 for OUT OF MH remove VAT (TAX REFUNDABLE)
				# 999 - 878 = 121
				if state != "Maharashtra"
					transfer_order_pricing.tax_refund = transfer_order_pricing.basic - transfer_order_pricing.basic_price
				else
					transfer_order_pricing.tax_refund = 0
				end
				# Step 4 Calculate commission for Basic and Shipping COD charges
				# 123 + 65 (out of MH) for MH (189 + 65)
				transfer_order_pricing.commission = transfer_order_pricing.landed_price * 0.14

				# Step 5 Reduce tax refundable and commission
				# Outside MH 1464 - (121 + 188) = 1155
				transfer_order_pricing.base_price = (transfer_order_pricing.landed_price ||= 0) - (transfer_order_pricing.commission ||= 0 )
				# Step 6  Reduce commission
				# In MH 1464 - (189) = 1163

				# Step 6 For MH Last Step Add VAT
				# in MH add VAT 0.125
				# 1163 + 145 = 1309
				if state == "Maharashtra"
					transfer_order_pricing.vat_charge = transfer_order_pricing.base_price * transfer_order_pricing.vat_percent
				end
				# Step 7 OUT OF MH Add CST and C Form Refundable Amount
				# CST = 0.02 C-Form Refundable = 0.105
				# 1155 + 23 + 121 = 1299
				# vat_charge, :cst, :c_form
				if state != "Maharashtra"
					transfer_order_pricing.c_form = transfer_order_pricing.base_price * 0.105
					transfer_order_pricing.cst = transfer_order_pricing.base_price * 0.02
				end
				transfer_order_pricing.final_total = transfer_order_pricing.base_price + (transfer_order_pricing.vat_charge ||= 0) + (transfer_order_pricing.c_form ||= 0) + (transfer_order_pricing.cst ||= 0)
				return transfer_order_pricing
			end
end
