class ProductSampleStock < ActiveRecord::Base
	 belongs_to :product_master, foreign_key: "product_master_id"
	 belongs_to :product_list, foreign_key: "product_list_id"
	 validates :product_master_id ,  :presence => { :message => "Please select product from list!" }
	 validates_uniqueness_of :product_master_id
	  validates :stock ,  :presence => { :message => "Please enter stock nos!" }

end
