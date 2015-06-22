class ProductMasterAddOn < ActiveRecord::Base
	 belongs_to :product_master, foreign_key: "product_master_id" 
	 belongs_to :product_list, foreign_key: "product_list_id" 

	belongs_to :product_active_code, foreign_key: "activeid"
	validates :product_master_id ,  :presence => { :message => "Please select main product!" }
  	validates :product_list_id,  :presence => { :message => "Please select the associated product!" } 
	 validates_uniqueness_of :product_list_id, :scope => [:product_master_id, :product_list_id], :message => "Not Saved, a product list has been saved earlier with the same spec! "

	 def ProductMaster
	 	ProductMaster.find("id = ?", self.product_master_id).productname
	 end

	 def replace_products
	 	if self.replace_by_product_id.present?
	 		orginal_product = ProductList.find(self.product_list_id).name
	 		replace_by_product = ProductList.find(self.replace_by_product_id).name
	 		return "This #{orginal_product} would be replaced by #{replace_by_product}"
	 	end
	 end
end
