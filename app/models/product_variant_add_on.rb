class ProductVariantAddOn < ActiveRecord::Base
	 belongs_to :product_master, foreign_key: "product_master_id"
	 belongs_to :product_variant, foreign_key: "product_variant_id"

	 validates_uniqueness_of :product_variant_id, scope: :product_master_id
end
