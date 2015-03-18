class ProductList < ActiveRecord::Base

	belongs_to :product_variant, foreign_key: "product_variant_id" 
	belongs_to :product_spec_list, foreign_key: "product_spec_list_id" 
	belongs_to :product_active_code, foreign_key: "active_status_id"
	
	#coding not completed for this
	#has_many :interaction_master, foreign_key: "productvariantid"
  	
  	#ordering is related to this
  	has_many :order_line, foreign_key: "product_list_id" #, polymorphic: true
  	validates_presence_of :extproductcode
  	validates_uniqueness_of :list_barcode, :allow_blank => true, :message => "This code has been used earlier, you may choose to leave it blank! "

  	validates_uniqueness_of :name, :scope => [:product_variant_id, :product_spec_list_id], :message => "Not Saved, a variant has been saved earlier with the same spec! "

  	def productinfo
     self.name << " (" << self.extproductcode << ")"
   end

end
