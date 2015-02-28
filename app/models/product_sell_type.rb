class ProductSellType < ActiveRecord::Base
	 has_many :product_master , foreign_key: "product_sell_type_id"
	 has_many :product_variant , foreign_key: "product_sell_type_id"

	def details
   self.name  + " (" + self.description + ")"
  end
end
