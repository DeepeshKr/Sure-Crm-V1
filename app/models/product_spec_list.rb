class ProductSpecList < ActiveRecord::Base
	 validates_uniqueness_of :name, allow_blank: true

	 has_many :product_list, foreign_key: "product_variant_id"
end
