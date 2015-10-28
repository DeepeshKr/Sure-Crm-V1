class ProductCostMaster < ActiveRecord::Base

	belongs_to :product_master, foreign_key: "product_id" #, polymorphic: true
  	belongs_to :product_list, foreign_key: "product_list_id"

	validates :prod ,  :presence => { :message => "Please select product!" }

def details
	self.product_master.name if self.product_master
end

	after_create :updateprice # :creator

  	after_save :updateprice # :updator

  	after_update :updateprice

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
