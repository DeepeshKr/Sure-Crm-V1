class DistributorStockLedger < ActiveRecord::Base
	attr_accessor  :flash_notice
	belongs_to :corporate, foreign_key: "corporate_id"
	belongs_to :product_master, foreign_key: "product_master_id"
	belongs_to :product_variant, foreign_key: "product_variant_id"
	belongs_to :product_list, foreign_key: "product_list_id"
	belongs_to :distributor_stock_ledger_type, foreign_key: "type_id"

	validates :corporate_id,  :presence => { :message => "Need to select a distributor!" }
	validates :ledger_date,  :presence => { :message => "Need to select a date for entry!" }
	#validates_presence_of :stock_change, :unless => :stock_value? #, { :message => "Need to select a stock change or keep the value 0" }
	#validates_presence_of :stock_value, :unless => :stock_change? #, { :message => "Need to select a stock change or keep the value 0" }
	#validates :stock_change,  :presence => { :message => "Need to select a stock change or keep the value 0" }
	validates :name,  :presence => { :message => "Need to give a name like stock addition, sale, bonus..." }
	validates :description,  :presence => { :message => "Description of ledger" }

def all_update_distributor_stock
	no_of_records = 0
	distributor_stock_ledgers = DistributorStockLedger.all
	distributor_stock_ledgers.each do |stock|
		update_product_details_for_id(stock.id)
		no_of_records += 1
	end
	return no_of_records
end
	#on create change update stock summary
	#on create change update stock summary
	after_create :update_product_details
	#after_create :update_product_stock_summary

	#after_update :update_product_details(self.id)
private
	def update_product_details_for_id(ledger_id)
		 distributor_stock_ledger = DistributorStockLedger.find(ledger_id)
		 #10001	Add Stock to Distributor
		 #10002	Remove Stock from Distributor
			if distributor_stock_ledger.product_list_id.present?
				#product list details from product master id
				product_list = ProductList.find(distributor_stock_ledger.product_list_id) #.joins(:product_variant).where("product_variants.activeid = 10000")
				if product_list.present?
					#product list details from product master id
					#distributor_stock_ledger = DistributorStockLedger.find(self.id)
					distributor_stock_ledger.update(product_master_id: product_list.product_master_id,
						product_variant_id: product_list.product_variant_id,
						prod: product_list.extproductcode)

						update_product_stock_summary(distributor_stock_ledger.id)

						self.flash_notice = "Ledger details updated with stock nos #{}"
				end

			elsif distributor_stock_ledger.type_id == 10000 #mis additions
						message = add_corporate_mis_balance(distributor_stock_ledger.corporate_id, distributor_stock_ledger.stock_value.to_f)
						self.flash_notice = "Ledger #{message}"
							 # flash[:error] = "Ledger details #{distributor_stock_ledger.type_id}"
		 elsif distributor_stock_ledger.type_id == 10020 #mis removal
						message = remove_corporate_mis_balance(distributor_stock_ledger.corporate_id, distributor_stock_ledger.stock_value.to_f)
						self.flash_notice = "Ledger #{message}"
			end

		#end
	end
	# on create update variant id and list id
	def update_product_details
			transferorderpricing = TransferOrderPricing.new
			corporate = Corporate.find(self.corporate_id)
			transferorderpricing = wholesale_price(self.product_list_id, corporate.state, corporate.commission_percent)
			self.update(stock_value: transferorderpricing.final_total)
       distributor_stock_ledger = DistributorStockLedger.find(self.id)
			 #10001	Add Stock to Distributor
			 #10002	Remove Stock from Distributor
	      if distributor_stock_ledger.product_list_id.present?
	        #product list details from product master id
	        product_list = ProductList.find(distributor_stock_ledger.product_list_id) #.joins(:product_variant).where("product_variants.activeid = 10000")
	        if product_list.present?
	          #product list details from product master id
	          #distributor_stock_ledger = DistributorStockLedger.find(self.id)
	          distributor_stock_ledger.update(product_master_id: product_list.product_master_id,
	            product_variant_id: product_list.product_variant_id,
	            prod: product_list.extproductcode)

							  message = update_product_stock_summary(distributor_stock_ledger.id)

							self.flash_notice = "Ledger details updated with stock nos #{message}"
	        end

	      elsif distributor_stock_ledger.type_id == 10000 #mis additions
	            message = add_corporate_mis_balance(distributor_stock_ledger.corporate_id, distributor_stock_ledger.stock_value.to_f)
							self.flash_notice = "Ledger #{message}"
	               # flash[:error] = "Ledger details #{distributor_stock_ledger.type_id}"
			 	elsif distributor_stock_ledger.type_id == 10020 #mis removal
				 message = " "
	            message += remove_corporate_mis_balance(distributor_stock_ledger.corporate_id, distributor_stock_ledger.stock_value.to_f)
							self.flash_notice = "Ledger #{message}"
	      end
  	  #end
  end

  def add_corporate_mis_balance(corporate_id, mis_value)
		 fin_value = 0.0
		 add_value = 0.0
     corporate = Corporate.find(corporate_id)
     fin_value = corporate.rupee_balance.to_f if corporate.rupee_balance.present?
     #flash[:notice] = "Corporate MIS Balance #{corporate.rupee_balance} updating to #{fin_value}"
		 mis_value = mis_value ||= 0 if mis_value.present?

		 add_value = fin_value + (mis_value ||= 0.0)
		corporate.update_attribute(:rupee_balance, add_value)

		 return "Added MIS Balance for #{corporate.name} id: #{corporate_id} with current #{fin_value} add  Rs #{mis_value} to make the total Rs #{add_value}"
  end

	def remove_corporate_mis_balance(corporate_id, mis_value)
		fin_value = 0.0
		reduce_value = 0.0
		corporate = Corporate.find(corporate_id)
		fin_value = corporate.rupee_balance.to_f if corporate.rupee_balance.present?

		# flash[:notice] = "Corporate MIS Balance #{corporate.rupee_balance} updating to #{reduce_value}"
			reduce_value = fin_value - (mis_value ||= 0.0)

     corporate.update_attribute(:rupee_balance, reduce_value)

		 return "Removed MIS Balance for #{corporate.name} id: #{corporate_id} from current #{fin_value} less Rs #{mis_value} to make the total Rs #{reduce_value}"
  end

  def update_product_stock_summary(distributor_stock_ledger_id)
		messages = ""
    distributor_stock_ledger = DistributorStockLedger.find(distributor_stock_ledger_id)
  	todaydate = (330.minutes).from_now.to_date
  	if distributor_stock_ledger.type_id != 10000
    if distributor_stock_ledger.product_list_id.present?
      #product list details from product master id
      product_list = ProductList.find(distributor_stock_ledger.product_list_id) #.joins(:product_variant).where("product_variants.activeid = 10000")
      if product_list.present?
        #product list details from product master id
         if DistributorStockSummary.where("product_list_id = ? and corporate_id = ?" , distributor_stock_ledger.product_list_id, distributor_stock_ledger.corporate_id).present?

           distributor_stock_summary = DistributorStockSummary.where("product_list_id = ? and corporate_id = ?" , distributor_stock_ledger.product_list_id, distributor_stock_ledger.corporate_id).first
        #   #get current balance
           balance_qty = distributor_stock_summary.stock_qty.to_f ||= 0
           balance_val = distributor_stock_summary.stock_value.to_f ||= 0
          if self.type_id == 10001 #Add
           balance_qty += distributor_stock_ledger.stock_change ||= 0
           balance_val += distributor_stock_ledger.stock_value ||= 0
					 messages += "Updated product with additional stock: #{distributor_stock_ledger.stock_value}"
          elsif self.type_id == 10002 #Remove
						#get the whole sale price for product
						final_corporate_stock_list = DistributorStockSummary.where(product_list_id: distributor_stock_ledger.product_list_id, corporate_id: distributor_stock_ledger.corporate_id).where("stock_qty > 0")

						if final_corporate_stock_list.present?
							#remove for corporate MIS Balance
							remove_corporate_mis_balance(distributor_stock_ledger.corporate_id, distributor_stock_ledger.stock_value)
							#distributor_stock_ledger.stock_value
							balance_qty -= distributor_stock_ledger.stock_change ||= 0
							balance_val -= distributor_stock_ledger.stock_value ||= 0

							 messages += "Updated product with reducing stock and reduce mis balance: #{distributor_stock_ledger.stock_value}"
						else
							corporate_stock_list = DistributorStockSummary.where(product_list_id: distributor_stock_ledger.product_list_id, corporate_id: distributor_stock_ledger.corporate_id)

							messages += "Unable to update product since stock is #{corporate_stock_list.first.stock_qty} and did not remove from mis balance: #{distributor_stock_ledger.stock_value} "
						end
          end

           distributor_stock_summary.update(product_master_id: product_list.product_master_id,
           product_variant_id: product_list.product_variant_id,
           prod: product_list.extproductcode,
           summary_date: distributor_stock_ledger.ledger_date,
           stock_qty: balance_qty, stock_value: balance_val)

         else

          DistributorStockSummary.create(product_list_id: distributor_stock_ledger.product_list_id,
          product_variant_id: distributor_stock_ledger.product_variant_id,
          product_master_id: distributor_stock_ledger.product_master_id,
          prod: distributor_stock_ledger.prod,
          corporate_id: distributor_stock_ledger.corporate_id,
          summary_date: distributor_stock_ledger.ledger_date,
          stock_qty: distributor_stock_ledger.stock_change,
          stock_value: distributor_stock_ledger.stock_value,
          stock_returned: 0)

        end
      end
    end
   end
		return messages
	end

	def wholesale_price(product_list_id, state, commission)
			commission = 0.14 if commission.blank?

			transfer_order_pricing = TransferOrderPricing.new
			productlists = ProductList.where(id: product_list_id)

			if productlists.blank?
				return transfer_order_pricing
			end

			productlist = productlists.first
			#productlist = ProductList.find()

			transfer_order_pricing.full_product_name = productlist.productname
			transfer_order_pricing.product_code
			transfer_order_pricing.state


			transfer_order_pricing.basic = productlist.product_variant.price
			transfer_order_pricing.shipping= productlist.product_variant.shipping

			transfer_order_pricing.for_state = state

			taxrates = TaxRate.where(name: state)
			transfer_order_pricing.vat_percent = 0.125
			transfer_order_pricing.reverse_rate = 0.88888889
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
			transfer_order_pricing.commission = transfer_order_pricing.landed_price * commission

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

		#10000	No Stock Change
		#10001	Add Stock to Distributor
		#10002	Remove Stock from Distributor

				# :product_master_id, :product_variant_id,
    #     :product_list_id, :prod,
    #     :stock_balance,
    #     :rupee_balance,
    #     :stock_returned,
    #     :summary_date
				#product variant details from product master id




end
