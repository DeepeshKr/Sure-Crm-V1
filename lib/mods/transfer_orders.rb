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

	def create_vpp(order_id)


	end


	def create_dealer_order(order_id)


	end

	def dealer_stock(order_id)


	end


end