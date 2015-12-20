class DistributorProductList < ActiveRecord::Base
  belongs_to :product_list, foreign_key: "product_list_id"
end
