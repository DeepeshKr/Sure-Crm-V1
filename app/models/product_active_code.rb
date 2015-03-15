class ProductActiveCode < ActiveRecord::Base
  has_many :product_master, foreign_key: "productactivecodeid"
  has_many :product_variants, foreign_key: "activeid"
  has_many :product_list, foreign_key: "active_status_id"

end
