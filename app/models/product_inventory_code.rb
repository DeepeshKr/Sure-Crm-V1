class ProductInventoryCode < ActiveRecord::Base
  has_many :product_master,  foreign_key: "productinventorycodeid"
end
