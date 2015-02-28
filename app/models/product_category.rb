class ProductCategory < ActiveRecord::Base
  has_many :product_masters, foreign_key: "productcategory_id"
end
