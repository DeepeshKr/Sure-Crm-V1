class ProductCostMaster < ActiveRecord::Base
  require 'csv'
	belongs_to :product_master, foreign_key: "product_id" #, polymorphic: true
  belongs_to :product_list, foreign_key: "product_list_id"
  belongs_to :product_variant, foreign_key: "product_variant_id"
  
	#validates :prod ,  :presence => { :message => "Please select product!" }
	validates :prod,  uniqueness: true #=> { :message => "This product was already entered!" }
  validates :product_variant_id,  uniqueness: true
  
  def details
  	self.product_master.name if self.product_master
  end
	after_create :updateprice # :creator
  #after_save :updateprice # :updator
  after_update :updateprice
  
  	# product_cost_master.prod, product_cost_master.basic_cost,
  	# product_cost_master.shipping_handling,  product_cost_master.product_cost,
  	# product_cost_master.postage,  product_cost_master.tel_cost,
  	# product_cost_master.royalty, product_cost_master.cost_of_return,
  	# product_cost_master.call_centre_commission,
  	# product_cost_master.transf_order_basic,
  	# product_cost_master.dealer_network_basic,
  	# product_cost_master.wholesale_variable_cost
  
  def update_price
      product_cost_master = ProductCostMaster.find(self.id)
    	m_revenue = (product_cost_master.basic_cost || 0) + (product_cost_master.shipping_handling || 0)              
      m_cost = (product_cost_master.product_cost || 0) + (product_cost_master.tel_cost || 0) +      (product_cost_master.postage || 0) + (product_cost_master.royalty || 0) + (product_cost_master.cost_of_return || 0) + (product_cost_master.call_centre_commission || 0) + (product_cost_master.packaging_cost || 0)

    	product_cost_master.update_columns(cost: m_cost, revenue: m_revenue)
  end
    
  def self.update_product_cost_master
    reverse_vat_rate = TaxRate.find(10001)
    reverse_ship_rate = TaxRate.find(10020)
    reverse_transfer_rate = TaxRate.find(10040)
    reverse_dealer_rate = TaxRate.find(10041)
    #check if the prod has pricing details entered
    #if not found create new record
    product_costs = ProductCostMaster.all #.limit(10)
    
    product_costs.each do |p|
      if p.product_variant_id.blank?
        create_product_cost_master p.product_variant_id
        next
      end
      
      product_variant = ProductVariant.find(p.product_variant_id)
      
      next if product_variant.blank?
      
      p.update(:basic_cost => product_variant.price * reverse_vat_rate.reverse_rate.to_f,
        :shipping_handling => product_variant.shipping * reverse_vat_rate.reverse_rate.to_f,
        :transf_order_basic => (product_variant.price * reverse_vat_rate.reverse_rate.to_f + product_variant.shipping * reverse_vat_rate.reverse_rate.to_f) * reverse_transfer_rate.reverse_rate.to_f,
        :dealer_network_basic => (product_variant.price * reverse_vat_rate.reverse_rate.to_f + product_variant.shipping * reverse_vat_rate.reverse_rate.to_f) * reverse_dealer_rate.reverse_rate.to_f,
        :product_variant_id => product_variant.id,
        prod: product_variant.extproductcode)
    end
  
  end
  
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
  
  def self.create_product_cost_master product_variant_id
   # product_variant_id = 15385

    return nil if product_variant_id.blank?
    reverse_vat_rate = TaxRate.find(10001)
    reverse_ship_rate = TaxRate.find(10020)
    reverse_transfer_rate = TaxRate.find(10040)
    reverse_dealer_rate = TaxRate.find(10041)
    #check if the prod has pricing details entered
    #if not found create new record
    product_variant = ProductVariant.find(product_variant_id)
    return nil if product_variant.blank?
    product_costs = ProductCostMaster.where(product_variant_id: product_variant_id)
    if product_costs.blank?

       product_cost_master = ProductCostMaster.create(prod: product_variant.extproductcode,
          product_id: product_variant.productmasterid,
          :product_variant_id => product_variant_id,
          :product_cost => 0,
          :basic_cost => product_variant.price * reverse_vat_rate.reverse_rate.to_f,
          :shipping_handling => product_variant.shipping * reverse_vat_rate.reverse_rate.to_f,
          :postage => 0,
          :tel_cost => 0,
          :transf_order_basic => (product_variant.price * reverse_vat_rate.reverse_rate.to_f + product_variant.shipping * reverse_vat_rate.reverse_rate.to_f) * reverse_transfer_rate.reverse_rate.to_f,
          :dealer_network_basic => (product_variant.price * reverse_vat_rate.reverse_rate.to_f + product_variant.shipping * reverse_vat_rate.reverse_rate.to_f) * reverse_dealer_rate.reverse_rate.to_f,
          :wholesale_variable_cost => 0,
          :royalty => 0,
          :cost_of_return => 0,
          :call_centre_commission => 0)
          
    else
      product_costs.each do |product_cost|
        product_cost.update(product_id: product_variant.productmasterid,
          prod: product_variant.extproductcode,
          :basic_cost => product_variant.price * reverse_vat_rate.reverse_rate.to_f,
          :shipping_handling => product_variant.shipping * reverse_vat_rate.reverse_rate.to_f,
          :transf_order_basic => (product_variant.price * reverse_vat_rate.reverse_rate.to_f + product_variant.shipping * reverse_vat_rate.reverse_rate.to_f) * reverse_transfer_rate.reverse_rate.to_f,
          :dealer_network_basic => (product_variant.price * reverse_vat_rate.reverse_rate.to_f + product_variant.shipping * reverse_vat_rate.reverse_rate.to_f) * reverse_dealer_rate.reverse_rate.to_f,
          :product_variant_id => product_variant.id)
      end
    end
  end
  
private
  def updateprice
  	#product_cost, :basic_cost, :shipping_handling, :product_cost, :tel_cost,
  	#:transf_order_basic, :dealer_network_basic, :wholesale_variable_cost,
  	#:royalty, :cost_of_return, :call_centre_commission
    product_cost_master = ProductCostMaster.find(self.id)
  	m_revenue = (product_cost_master.basic_cost || 0) + (product_cost_master.shipping_handling || 0)

  	m_cost = (product_cost_master.product_cost || 0) + (product_cost_master.tel_cost || 0) +      (product_cost_master.postage || 0) + (product_cost_master.royalty || 0) + (product_cost_master.cost_of_return || 0) + (product_cost_master.call_centre_commission || 0) + (product_cost_master.packaging_cost || 0)

  	product_cost_master.update_columns(cost: m_cost, revenue: m_revenue)
  end
  
  def update_price_on_update id
    product_cost_master = ProductCostMaster.find(self.id)
  	m_revenue = (product_cost_master.basic_cost || 0) + (product_cost_master.shipping_handling || 0)

  	m_cost = (product_cost_master.product_cost || 0) + (product_cost_master.tel_cost || 0) +      (product_cost_master.postage || 0) + (product_cost_master.royalty || 0) + (product_cost_master.cost_of_return || 0) + (product_cost_master.call_centre_commission || 0) + (product_cost_master.packaging_cost || 0)


  	product_cost_master.update_columns(cost: m_cost, revenue: m_revenue)
  end
  
end
