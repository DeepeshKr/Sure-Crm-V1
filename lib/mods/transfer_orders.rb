module TransferOrders
	def check_transfer(order_id)

		order_pin = OrderMaster.where(external_order_no: order_id).first.pincode

		#valid pincode
		dis_pin = DistributorPincodeList.where(pincode: order_pin)

		#check if order from valid pincode
		if dis_pin.present?
			#check if dealer mis balance more than order value
			if dis_pin.corporate.rupee_balance.present?


				#create dealer trail for less mis balance

			#check of dealer has stock for all products orders

				#create dealer trail for product orders missing
			end #rupee balance check
		end # distributor pin found
		
	end

	def create_vpp(order_id)


	end

	def create_dealer_order(order_id)


	end

	def dealer_stock(order_id)


	end


end