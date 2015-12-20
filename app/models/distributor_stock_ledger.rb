class DistributorStockLedger < ActiveRecord::Base
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
attr_accessor  :flash_notice
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
	            message = remove_corporate_mis_balance(distributor_stock_ledger.corporate_id, distributor_stock_ledger.stock_value.to_f)
							self.flash_notice = "Ledger #{message}"
	      end
  	  #end
    end

    def add_corporate_mis_balance(corporate_id, mis_value)

       corporate = Corporate.find(corporate_id)
       fin_value = corporate.rupee_balance.to_f || 0.0 if corporate.rupee_balance.present?
       #flash[:notice] = "Corporate MIS Balance #{corporate.rupee_balance} updating to #{fin_value}"
			 fin_value += mis_value

			corporate.update_attribute(:rupee_balance, fin_value)

			 return "Added MIS Balance for #{corporate.name} id: #{corporate_id} with Rs #{mis_value} to make the total Rs #{fin_value}"
    end

		def remove_corporate_mis_balance(corporate_id, mis_value)

       corporate = Corporate.find(corporate_id)
       fin_value = corporate.rupee_balance.to_f || 0.0 if corporate.rupee_balance.present?
       #flash[:notice] = "Corporate MIS Balance #{corporate.rupee_balance} updating to #{fin_value}"
				 fin_value -= mis_value


       corporate.update_attribute(:rupee_balance, fin_value)

			 return "Removed MIS Balance for #{corporate.name} id: #{corporate_id} with Rs #{mis_value} to make the total Rs #{fin_value}"
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
           if DistributorStockSummary.where("product_list_id = ? and corporate_id = ?",distributor_stock_ledger.product_list_id, distributor_stock_ledger.corporate_id).present?

             distributor_stock_summary = DistributorStockSummary.where("product_list_id = ? and corporate_id = ?",distributor_stock_ledger.product_list_id, distributor_stock_ledger.corporate_id).first
          #   #get current balance
             balance_qty = distributor_stock_summary.stock_qty.to_f ||= 0
             balance_val = distributor_stock_summary.stock_value.to_f ||= 0
            if self.type_id == 10001 #Add
             balance_qty += distributor_stock_ledger.stock_change ||= 0
             balance_val += distributor_stock_ledger.stock_value ||= 0
						 messages = "Updated product with additional stock: #{distributor_stock_ledger.stock_value}"
            elsif self.type_id == 10002 #Remove
							balance_qty -= distributor_stock_ledger.stock_change ||= 0
              balance_val -= distributor_stock_ledger.stock_value ||= 0
							 messages = "Updated product with reducing stock: #{distributor_stock_ledger.stock_value}"
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
