module ProductPricing

	# attr_accessor :basic, :shipping, :cod, :total_product_price, :vat_percent, :commission, :tax_refund, :base_price, :vat_charge, :cst, :c_form, :final_total, :full_product_name, :for_state, :reverse_rate, :landed_price, :basic_price

	def retail_price(prod)
		attr_accessor(basic, shipping, cod, credit_card)
	end

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
		(transfer_order_pricing.total_product_price = (transfer_order_pricing.basic ||= 0) + (transfer_order_pricing.shipping ||= 0 ) + (transfer_order_pricing.cod ||= 0)).to_i ||= 0
		# Step 2 if state not MH remove taxes (TAX REFUNDABLE)
		# Reduce VAT from Basic e.g. Rest 0.8810572687 / MH 0.88888889
		# basic now becomes 878	888
		# add shipping + cod charge 878 + 395 + 70 === 888 + 395 + 70

		(transfer_order_pricing.basic_price = transfer_order_pricing.basic * transfer_order_pricing.reverse_rate).to_i ||= 0

		(transfer_order_pricing.landed_price = (transfer_order_pricing.basic_price ||= 0) + (transfer_order_pricing.shipping ||= 0 ) + (transfer_order_pricing.cod ||= 0)).to_i ||= 0
		# Step 3 for OUT OF MH remove VAT (TAX REFUNDABLE)
		# 999 - 878 = 121
		if state != "Maharashtra"
			(transfer_order_pricing.tax_refund = transfer_order_pricing.basic - transfer_order_pricing.basic_price).to_i ||= 0
		else
			transfer_order_pricing.tax_refund = 0
		end
		# Step 4 Calculate commission for Basic and Shipping COD charges
		# 123 + 65 (out of MH) for MH (189 + 65)
		(transfer_order_pricing.commission = transfer_order_pricing.landed_price * 0.14).to_i ||= 0

		# Step 5 Reduce tax refundable and commission
		# Outside MH 1464 - (121 + 188) = 1155
		(transfer_order_pricing.base_price = (transfer_order_pricing.landed_price ||= 0) - (transfer_order_pricing.commission ||= 0 )).to_i ||= 0
		# Step 6  Reduce commission
		# In MH 1464 - (189) = 1163

		# Step 6 For MH Last Step Add VAT
		# in MH add VAT 0.125
		# 1163 + 145 = 1309
		if state == "Maharashtra"
			(transfer_order_pricing.vat_charge = transfer_order_pricing.base_price * transfer_order_pricing.vat_percent).to_i ||= 0
		end
		# Step 7 OUT OF MH Add CST and C Form Refundable Amount
		# CST = 0.02 C-Form Refundable = 0.105
		# 1155 + 23 + 121 = 1299
		# vat_charge, :cst, :c_form
		if state != "Maharashtra"
			(transfer_order_pricing.c_form = transfer_order_pricing.base_price * 0.105).to_i ||= 0
			(transfer_order_pricing.cst = transfer_order_pricing.base_price * 0.02).to_i ||= 0
		end
		(transfer_order_pricing.final_total = transfer_order_pricing.base_price + (transfer_order_pricing.vat_charge ||= 0) + (transfer_order_pricing.c_form ||= 0) + (transfer_order_pricing.cst ||= 0)).to_i ||= 0
		return transfer_order_pricing
	end
end
