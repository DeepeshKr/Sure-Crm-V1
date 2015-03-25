class ProductMasterAddOn < ActiveRecord::Base
	 belongs_to :product_master, foreign_key: "product_master_id" 
	 belongs_to :product_list, foreign_key: "product_list_id" 

	belongs_to :product_active_code, foreign_key: "activeid"
	 validates_uniqueness_of :product_list_id, :scope => [:product_master_id, :product_list_id], :message => "Not Saved, a product list has been saved earlier with the same spec! "

	 def ProductMaster
	 	ProductMaster.find("id = ?", self.product_master_id).productname
	 end
end
