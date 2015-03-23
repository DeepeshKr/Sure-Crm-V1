class ProductActiveCode < ActiveRecord::Base
  has_many :product_master, foreign_key: "productactivecodeid"
  has_many :product_variant, foreign_key: "activeid"
  has_many :product_list, foreign_key: "active_status_id"
   has_many :product_master_add_on, foreign_key: "activeid"
end
