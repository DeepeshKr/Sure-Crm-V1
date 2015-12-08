class ProductCostMaster < ActiveRecord::Base
require 'csv'
	belongs_to :product_master, foreign_key: "product_id" #, polymorphic: true
  belongs_to :product_list, foreign_key: "product_list_id"

	#validates :prod ,  :presence => { :message => "Please select product!" }
	validates :prod,  uniqueness: true #=> { :message => "This product was already entered!" }
def details
	self.product_master.name if self.product_master
end

	after_create :updateprice # :creator

  	after_save :updateprice # :updator

  	after_update :updateprice
  	# product_cost_master.prod, product_cost_master.basic_cost,
  	# product_cost_master.shipping_handling,  product_cost_master.product_cost,
  	# product_cost_master.postage,  product_cost_master.tel_cost,
  	# product_cost_master.royalty, product_cost_master.cost_of_return,
  	# product_cost_master.call_centre_commission,
  	# product_cost_master.transf_order_basic,
  	# product_cost_master.dealer_network_basic,
  	# product_cost_master.wholesale_variable_cost
def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|

      product_cost_master_hash = row.to_hash # exclude the price field
      product_cost_master_list = ProductCostMaster.where(prod: product_cost_master_hash["prod"])

      if product_cost_master_list.present?
      	#add execption
      	product_cost_master_list.update(basic_cost: product_cost_master_hash["basic_cost"],
        	shipping_handling:  product_cost_master_hash["shipping_handling"],
        	product_cost:  product_cost_master_hash["product_cost"],
        	postage:  product_cost_master_hash["postage"],
        	tel_cost:  product_cost_master_hash["tel_cost"],
        	royalty:  product_cost_master_hash["royalty"],
        	cost_of_return:  product_cost_master_hash["cost_of_return"],
        	call_centre_commission:  product_cost_master_hash["call_centre_commission"],
        	transf_order_basic:  product_cost_master_hash["transf_order_basic"],
        	dealer_network_basic:  product_cost_master_hash["dealer_network_basic"],
        	wholesale_variable_cost:  product_cost_master_hash["wholesale_variable_cost"])

    else

       ProductCostMaster.create(prod: product_cost_master_hash["prod"],
        	basic_cost: product_cost_master_hash["basic_cost"],
        	shipping_handling:  product_cost_master_hash["shipping_handling"],
        	product_cost:  product_cost_master_hash["product_cost"],
        	postage:  product_cost_master_hash["postage"],
        	tel_cost:  product_cost_master_hash["tel_cost"],
        	royalty:  product_cost_master_hash["royalty"],
        	cost_of_return:  product_cost_master_hash["cost_of_return"],
        	call_centre_commission:  product_cost_master_hash["call_centre_commission"],
        	transf_order_basic:  product_cost_master_hash["transf_order_basic"],
        	dealer_network_basic:  product_cost_master_hash["dealer_network_basic"],
        	wholesale_variable_cost:  product_cost_master_hash["wholesale_variable_cost"])


      end # end if !pincode_list.nil?
    end # end CSV.foreach
end # end self.import(file)

private
def updateprice
	#product_cost, :basic_cost, :shipping_handling, :product_cost, :tel_cost,
	#:transf_order_basic, :dealer_network_basic, :wholesale_variable_cost,
	#:royalty, :cost_of_return, :call_centre_commission
	m_revenue = (self.basic_cost || 0) + (self.shipping_handling || 0)

	 m_cost = (self.product_cost || 0) + (self.tel_cost || 0) + (self.postage || 0) + (self.royalty || 0) + (self.cost_of_return || 0) + (self.call_centre_commission || 0)



	self.update_columns(cost: m_cost, revenue: m_revenue)
end
end
